#!/usr/bin/env ruby
#
# Name:         daeva (Download and Automatically Enable Various Applications)
# Version:      0.8.5
# Release:      1
# License:      CC-BA (Creative Commons By Attribution)
#               http://creativecommons.org/licenses/by/4.0/legalcode
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: OS X
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Ruby script to download VLC nightly build
#               Unpacks, installs, and deals with Gatekeeper so app can run

# Required modules

require 'getopt/std'
require 'net/http'
require 'uri'
require 'date'
require 'versionomy'
require 'mechanize'
require 'selenium-webdriver'
require 'phantomjs'

# Variables

options  = "aC:c:d:g:hi:l:p:P:q:r:s:u:vVzZ:"

# Global variables

$pkg_info = {}
$verbose  = 0
$work_dir = "/tmp/daeva"
$mtime    = "7"
$pkg_dir  = File.dirname($0)+"/apps"

if !$pkg_dir =~ /\//
  $pkg_dir = Dir.pwd+"/apps"
end

# Load package code

if File.directory?($pkg_dir)
  Dir.entries($pkg_dir).grep(/rb$/) do |pkg_code|
    app_file = $pkg_dir+"/"+pkg_code
    require app_file
  end
end

# Print the version of the script

def print_version()
  puts
  file_array = IO.readlines $0
  version    = file_array.grep(/^# Version/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  packager   = file_array.grep(/^# Packager/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  name       = file_array.grep(/^# Name/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  puts name+" v. "+version+" "+packager
  puts
end

# Print information regarding the usage of the script

def print_usage(options)
  puts
  puts "Usage: "+$0+" -["+options+"]"
  puts
  puts "-V:\tDisplay version information"
  puts "-h:\tDisplay usage information"
  puts "-v:\tVerbose output"
  puts "-d:\tDownload latest build but don't install"
  puts "-i:\tDownload and install latest build"
  puts "-u:\tUpdate application to latest build"
  puts "-l:\tGet local build date for application"
  puts "-r:\tGet remote build date for application"
  puts "-p:\tGet URL of download for latest package"
  puts "-c:\tCompare local and remote build dates"
  puts "-a:\tShow available packages"
  puts "-g:\tUpdate Gatekeeper and Quarantine information so application can run"
  puts "-z:\tClean up temporary directory (delete files older than "+$mtime+" days)"
  puts "-Z:\tRemove existing application"
  puts "-C:\tRemove crash reporter file"
  puts "-P:\tPerform post install"
  puts "-q:\tQuit application"
  puts "-s:\tStart application"
  puts
end

# Remove any Crash Reporter files that may exist

def remove_crash(app_name)
  user_name  = %x[whoami].chomp
  crash_dir  = "/Users/"+user_name+"/Library/Application Support/CrashReporter"
  crash_file = %x[find "#{crash_dir}" -name "#{app_name}_*"].chomp
  if File.exist?(crash_file)
    if $verbose == 1
      puts "Deleting crash file: "+crash_file
    end
    %x[rm "#{crash_file}"]
  end
  return
end

# Get macupdate URL

def get_macupdate_url(app_name,app_url)
  pkg_type = get_pkg_type(app_name)
  pkg_page = Net::HTTP.get(URI.parse(app_url))
  pkg_url  = pkg_page.split("\n").grep(/mudesktop/)[0]
  if !pkg_url
    pkg_url = pkg_page.split("\n").grep(/dmg/)[0].split(/'/)[1]
    pkg_url = "http://www.macupdate.com"+pkg_url
  else
    if pkg_url.match(/#{pkg_type}/)
      pkg_url = pkg_url.split(/"/)[3].gsub(/mudesktop:\//,"http://www.macupdate.com")
    else
      if !pkg_url
        pkg_url = pkg_page.split("\n").grep(/dmg/)[0].split(/'/)[1]
        pkg_url = "http://www.macupdate.com"+pkg_url
      else
        if !pkg_url.match(/#{pkg_type}/)
          pkg_url = pkg_url.split(/"/)[3].gsub(/mudesktop/,"http://www.macupdate.com")
        else
          pkg_url  = URI.parse(pkg_page).split("\n").grep(/#{pkg_type}/)[1]
          if pkg_url.match(/'/)
            if pkg_url.match(/onclick/)
              pkg_url = pkg_url.split(/href="/)[1].split(/"/)[0].gsub(/mudesktop|mudesktop:\//,"http://www.macupdate.com")
            else
              pkg_url = pkg_url.split(/'/)[1]
              pkg_url = "http://www.macupdate.com"+pkg_url
            end
          else
            pkg_url = pkg_url.split(/">/)[1].split(/</)[0]
          end
        end
      end
    end
  end
  return pkg_url
end

# Get macupdate version

def get_macupdate_ver(app_name,app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/Version/).grep(/[0-9]:/)[0].split(/Version\s+/)[1].split(/:/)[0]
  if !rem_ver
    rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/Version/)[5].split(/Version\s+/)[2].split(/:/)[0]
  end
  if rem_ver.match(/javascript/)
    rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/Version/)[6].split(/Version\s+/)[1].split(/:/)[0]
  end
  if rem_ver.match(/history/)
    rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/Version/)[6].split(/Version\s+/)[1].split(/:/)[0].split(/\s+/)[0]
  end
  return rem_ver
end

# Get the type of application (e.g. app, prefPane, etc)

def get_app_type(app_name)
  app_type = eval("get_#{app_name.downcase.gsub(/ |-/,'_')}_app_type()")
  return app_type
end

# Get the name of the application

def get_app_name(app_name)
  app_file = $pkg_dir+"/"+app_name.downcase.gsub(/ |-/,'_')+".rb"
  if File.exist?(app_file)
    app_name = eval("get_#{app_name.downcase.gsub(/ |-/,'_')}_app_name()")
  else
    app_list = Dir.entries($pkg_dir)
    tmp_name = app_list.grep(/#{app_name.downcase.gsub(/ |-/,'_')}/)[0]
    if tmp_name
      tmp_name = tmp_name.gsub(/\.rb/,"")
    else
      puts
    end
    if tmp_name =~ /[A-z]/
      if $verbose == 1
        puts "Application profile "+app_name+" not found"
        puts "Found profile "+tmp_name
      end
      app_name = eval("get_#{tmp_name.downcase.gsub(/ |-/,'_')}_app_name()")
    else
      puts "Application "+app_name+" not found"
      puts
      puts "Available Applications:"
      puts
      print_avail_pkgs()
      puts
      exit
    end
  end
  return app_name
end

# Restart application if needed

def restart_app(app_name)
  app_type = get_app_type(app_name)
  app_dir  = get_app_dir(app_name)
  case app_type
  when /prefPane/
    %x[pkill "System Preferences"]
    %x[open "/Applications/System Preferences.app"]
  when /app|util/
    %x[pkill "#{app_name}"]
    %x[open "#{app_dir}"]
  end
  return
end

# Get the URL of the application information page

def get_app_url(app_name)
  app_file = $pkg_dir+"/"+app_name.downcase+".rb"
  if File.exist?(app_file)
    app_url = eval("get_#{app_name.downcase.gsub(/ |-/,'_')}_app_url()")
  else
    puts "Application "+app_name+" not found"
  end
  return app_url
end

# Get the directory where the application is installed or is going to be installed

def get_app_dir(app_name)
  app_dir  = ""
  app_type = get_app_type(app_name)
  case app_type
  when /bin/
    app_dir = "/usr/local/"+app_type
  when /app|run/
    if app_name.match(/avast/)
      app_dir = "/Applications/"+app_name+"!."+app_type
    else
      app_dir = "/Applications/"+app_name+"."+app_type
    end
  when /util/
    app_dir = "/Applications/Utilities/"+app_name+"."+app_type
  when /prefPane/
    app_dir = Dir.home+"/Library/PreferencePanes/"+app_name+"."+app_type
  end
  return app_dir
end

# Get the long version of the application, e.g. major and minor version info

def get_min_ver(app_name)
  min_ver  = ""
  app_dir  = get_app_dir(app_name)
  ver_file = app_dir+"/Contents/Info.plist"
  if File.exist?(ver_file)
    cf_check = %x[cat "#{ver_file}" | grep CFBundleVersion]
    if cf_check.match(/CFBundleVersion/)
      min_ver = %x[defaults read "#{ver_file}" CFBundleVersion].chomp
    end
  else
    if $verbose == 1
      puts "Application information file "+ver_file+" does not exist"
    end
    min_ver = "Not Installed"
  end
  return min_ver
end

# Get local application version

def get_app_ver(app_name)
  app_ver  = ""
  app_dir  = get_app_dir(app_name)
  ver_file = app_dir+"/Contents/Info.plist"
  if File.exist?(ver_file)
    cf_check = %x[cat "#{ver_file}" | grep CFBundleGetInfoString]
    if cf_check.match(/CFBundleGetInfoString/)
      app_ver = %x[defaults read "#{ver_file}" CFBundleGetInfoString].chomp
    end
    if app_ver !~ /[0-9]\.[0-9]/
      cf_check = %x[cat "#{ver_file}" | grep CFBundleShortVersionString]
      if cf_check.match(/CFBundleShortVersionString/)
        app_ver = %x[defaults read "#{ver_file}" CFBundleShortVersionString].chomp
      end
    end
    if !app_ver
      app_ver = get_min_ver(app_name)
    else
      if !app_ver.match(/[0-9]/)
        app_ver = get_min_ver(app_name)
      end
    end
    app_ver = app_ver.gsub(/#{app_name} /,"")
  else
    if $verbose == 1
      puts "Application information file "+ver_file+" does not exist"
    end
    app_ver = "Not Installed"
  end
  return app_ver
end

# For applications that are compared on date (e.g. nightly builds)

def get_app_date(app_name)
  app_dir = get_app_dir(app_name)
  app_bin = app_dir+"/Contents/MacOS/"+app_name
  if File.directory?(app_dir)
    if File.exist?(app_bin)
      app_date = File.mtime(app_bin)
      app_date = DateTime.parse(app_date.to_s).to_date
    else
      app_date = "Not Installed"
      if $verbose == 1
        puts "Application "+app_bin+" does not exist"
      end
    end
  else
    app_date = "Not Installed"
    if $verbose == 1
      puts "Directory "+app_dir+" does not exist"
    end
  end
  return app_date
end

# Get the local (installed) version

def get_loc_ver(app_name)
  loc_ver = eval("get_#{app_name.downcase.gsub(/ |-/,'_')}_loc_ver(app_name)")
  if loc_ver.to_s.match(/Installed/)
    loc_ver = "Not Installed"
  end
  return loc_ver
end

# Get the remote (web) version

def get_rem_ver(app_name)
  app_url = get_app_url(app_name)
  if $verbose == 1
    puts "Getting version (or date) of latest release from #{app_url}"
  end
  rem_ver = eval("get_#{app_name.downcase.gsub(/ |-/,'_')}_rem_ver(app_name,app_url)")
  if rem_ver.to_s !~ /[0-9]/
    puts "Remote build version (or date) not found"
    exit
  end
  return rem_ver
end

# Compare the local version of the app with the remote version

def compare_build_vers(loc_ver,rem_ver)
  if loc_ver.to_s.match(/No/)
    result = 0
  else
    if rem_ver.to_s.match(/-/) and !rem_ver.to_s.match(/beta/)
      if $verbose == 1
        puts "Local build date:  "+loc_ver.to_s
        puts "Remote build date: "+rem_ver.to_s
      end
      if rem_ver.to_time > loc_ver.to_time
        result = 0
      else
        result = 1
      end
    else
      if $verbose == 1
        puts "Local build version:  "+loc_ver
        puts "Remote build version: "+rem_ver
      end
      if loc_ver !~ /No/
        loc_ver = Versionomy.parse(loc_ver)
        rem_ver = Versionomy.parse(rem_ver)
        if rem_ver > loc_ver
          result = 0
        else
          result = 1
        end
      else
        result = 2
      end
    end
  end
  if result == 0
    puts "Remote version of build is newer than local"
  else
    if result == 1
      puts "Local version of build is up to date"
    else
      puts "Local version could not be accurately determined"
    end
  end
  return result
end

def get_app_url(app_name)
  app_url = eval("get_#{app_name.downcase.gsub(/ |-/,'_')}_app_url()")
  return app_url
end


def get_pkg_url(app_name)
  app_url = get_app_url(app_name)
  pkg_url = eval("get_#{app_name.downcase.gsub(/ |-/,'_')}_pkg_url(app_name,app_url)")
  return pkg_url
end

def check_pkg_file(pkg_file)
  if File.exist?(pkg_file)
    file_type = %x[file #{pkg_file}]
    if file_type.match(/html|HTML|empty/)
      File.delete(pkg_file)
    end
  end
  return
end

def get_pkg_file(app_name,app_url,pkg_url,pkg_file)
  check_pkg_file(pkg_file)
  if !File.exist?(pkg_file)
    if $verbose == 1
      puts "Downloading "+pkg_url+" to "+pkg_file
    end
    agent = Mechanize.new
    agent.redirect_ok = true
    agent.pluggable_parser.default = Mechanize::Download
    begin
      if app_name =~ /TinkerTool/
        cap = Selenium::WebDriver::Remote::Capabilities.phantomjs('phantomjs.page.settings.userAgent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10) AppleWebKit/538.39.41 (KHTML, like Gecko) Version/8.0 Safari/538.39.41')
        doc = Selenium::WebDriver.for :phantomjs, :desired_capabilities => cap
        doc.get(pkg_url)
        doc.find_element(:id => "Download").click
        file = File.open(pkg_file,"w")
        file.write(doc.page_source)
        file.close
      else
        agent.get(pkg_url).save(pkg_file)
      end
    rescue
      puts "Error fetching: "+pkg_url
      exit
    end
  else
    if $verbose == 1
      puts "File"+pkg_file+" already exits, skipping download"
    end
  end
  return
end

def get_pkg_type(app_name)
  pkg_type = eval("get_#{app_name.downcase.gsub(/ |-/,'_')}_pkg_type()")
  return pkg_type
end

def download_app(app_name,app_url,pkg_url,rem_ver)
  if pkg_url =~ /dmg$|zip$/
    suffix = pkg_url.split(/\./)[-1]
  else
    suffix = get_pkg_type(app_name)
  end
  pkg_file = $work_dir+"/"+app_name.downcase.gsub(/ |-/,'_')+"-"+rem_ver.to_s+"."+suffix
  check_pkg_file(pkg_file)
  if !File.exist?(pkg_file)
    get_pkg_file(app_name,app_url,pkg_url,pkg_file)
  else
    if $verbose == 1
      puts pkg_file+" already exists"
    end
  end
  return pkg_file
end

def unzip_app(app_name,zip_file)
  app_type = get_app_type(app_name)
  if File.exist?(zip_file)
    zip_test = %x[unzip -q -t #{zip_file} 2>&1]
    zip_dir  = File.dirname(zip_file)
  else
    puts "Zip file "+zip_file+" does not exist"
    exit
  end
  if zip_test =~ /No errors/
    if $verbose == 1
      %x[cd #{$work_dir} ; unzip -d "#{zip_dir}" -o #{zip_file}]
    else
      %x[cd #{$work_dir} ; unzip -d "#{zip_dir}" -q -o #{zip_file} 2>&1 /dev/null]
    end
  else
    puts "Zip file "+zip_file+" contains errors"
    exit
  end
  app_dir = zip_dir+"/"+app_name+".app"
  if !File.directory?(app_dir)
    if app_type.match(/bin/)
      if app_name.match(/ /)
        base_dir = %x[unzip -l "#{zip_file}" |tr '[:upper:]' '[:lower:]' |awk '{print $4" "$5"}' |grep "#{app_name.downcase}" |grep "/$" |head -1].chomp.split(/\//)[0..-2].join("/")
      else
        base_dir = %x[unzip -l "#{zip_file}" |tr '[:upper:]' '[:lower:]' |awk '{print $4}' |grep "#{app_name.downcase}" |grep "/$" |head -1].chomp.split(/\//)[0..-2].join("/")
      end
    else
      if app_name.match(/ /)
        base_dir = %x[unzip -l "#{zip_file}" |awk '{print $4" "$5"}' |grep "#{app_name}.app" |grep "/$" |head -1].chomp.split(/\//)[0..-2].join("/")
      else
        base_dir = %x[unzip -l "#{zip_file}" |awk '{print $4}' |grep "#{app_name}.app" |grep "/$" |head -1].chomp.split(/\//)[0..-2].join("/")
      end
    end
    zip_dir = zip_dir+"/"+base_dir.gsub(/\/$/,"")
  end
  if !File.directory?(zip_dir)
    puts "Warning:\tSource directory "+zip_dir+" could not be found for "+app_name
    exit
  end
  return zip_dir
end

def quit_app(app_name)
  app_pid = %x[pgrep "#{app_name}"].chomp.to_s
  if app_pid
    if app_pid.match(/[0-9]/)
      if $verbose == 1
        puts "Quiting "+app_name
      end
      %x[osascript -e 'tell application "#{app_name}" to quit']
    end
  else
    app_pid = "Not Running"
  end
  return app_pid
end

def get_dest_dir(app_name)
  dest_dir = ""
  app_type = get_app_type(app_name)
  case app_type
  when /app|run/
    dest_dir = "/Applications"
  when /util/
    dest_dir = "/Applications/Utilities"
  when /bin/
    dest_dir = "/usr/local"
  when /prefPane/
    dest_dir = Dir.home+"/Library/PreferencePanes"
  end
  if $verbose == 1
    puts "Setting destination directory to "+dest_dir
  end
  return dest_dir
end

def get_pkg_dir(app_name,tmp_dir)
  app_type = get_app_type(app_name)
  pkg_type = get_pkg_type(app_name)
  case app_type
  when /bin/
    pkg_dir = app_type
  else
    pkg_dir = app_name+"."+app_type
  end
  pkg_dir = tmp_dir+"/"+pkg_dir
  return pkg_dir
end

def get_pkg_bin(app_name,tmp_dir,rem_ver)
  os_rel = %x[uname -r |cut -f1 -d.].chomp.to_i
  case app_name
  when /avast/
    pkg_bin = tmp_dir+"/"+app_name+"!.pkg"
  when /Splunk/
    pkg_bin = tmp_dir+"/.payload/"+app_name+".pkg"
  when /puppet|facter|hiera/
    pkg_bin = tmp_dir+"/"+app_name+"-"+rem_ver+".pkg"
  when /OpenZFS/
    if os_rel >= 13
      pkg_bin = tmp_dir+"/OpenZFS on OS X "+rem_ver+" Mavericks or higher.pkg"
    else
      pkg_bin = tmp_dir+"/OpenZFS on OS X "+rem_ver+" Mountain Lion.pkg"
    end
  else
    pkg_bin = tmp_dir+"/"+app_name+".pkg"
  end
  return pkg_bin
end

def copy_app(app_name,tmp_dir,rem_ver)
  app_dir  = get_app_dir(app_name)
  dest_dir = get_dest_dir(app_name)
  app_type = get_app_type(app_name)
  remove_app(app_name)
  if File.directory?(tmp_dir)
    app_pid = quit_app(app_name)
    if app_type.match(/zip/)
      pkg_dir = tmp_dir
    else
      pkg_dir = get_pkg_dir(app_name,tmp_dir)
    end
    pkg_bin = get_pkg_bin(app_name,tmp_dir,rem_ver)
    if File.exist?(pkg_bin) or File.symlink?(pkg_bin)
      if $verbose == 1
        puts "Installing Application from "+pkg_bin+" to #{app_dir}"
      end
      if app_type.match(/run/)
        system("open \"#{pkg_bin}\"")
      else
        system("sudo sh -c '/usr/sbin/installer -pkg \"#{pkg_bin}\" -target /'")
      end
    else
      if File.directory?(pkg_dir)
        if $verbose == 1
          puts "Copying Application from "+tmp_dir+" to #{app_dir}"
        end
        %x[cd "#{tmp_dir}" ; sudo cp -rp "#{pkg_dir}" "#{dest_dir}" 2>&1]
      else
        puts "Could not find source directory "+pkg_dir
      end
    end
    user_id = %x[whoami].chomp
    if File.directory?(app_dir) and app_name != "VirtualBox"
      %x[sudo chown -R #{user_id} "#{app_dir}"]
    end
  else
    puts "Directory "+tmp_dir+" does not exist "
    exit
  end
  return app_pid
end

def attach_dmg(app_name,pkg_file)
  system("sudo sh -c 'echo Y | hdiutil attach \"#{pkg_file}\" |tail -1 |cut -f3-'")
  tmp_dir = %x[ls -rt /Volumes |grep "#{app_name}" |tail -1].chomp
  tmp_dir = "/Volumes/"+tmp_dir
  if tmp_dir !~ /[A-z]/
    tmp_dir = "/Volumes/"+app_name
  end
  if $werbose == 1
    puts "DMG mounted on "+tmp_dir
  end
  return tmp_dir
end

def copy_tar(app_name,pkg_file)
  app_pid = quit_app(app_name)
  if File.exist?(pkg_file)
    case pkg_file
    when /bz2$/
      %x[cd /Applications ; tar -xpjf #{pkg_file}]
    when /gz$/
      %x[cd /Applications ; tar -xpf #{pkg_file}]
    end
  end
  return app_pid
end

def detach_dmg(tmp_dir)
  %x[sudo hdiutil detach "#{tmp_dir}"]
  return
end

def start_app(app_name)
  app_pid = %x[pgrep "#{app_name}"].chomp.to_s
  if !app_pid.match(/[0-9]/)
    %x[open -a "#{app_name}"]
  else
    if $verbose == 1
      puts "Application already running"
    end
  end
  return
end

def install_app(app_name,pkg_file,rem_ver)
  if File.exist?(pkg_file)
    file_type = %x[file #{pkg_file}].chomp
    case pkg_file
    when /tar\.bz2$|tbz2$/
      if file_type =~ /bzip2 compressed data/
        app_pid = copy_tar(app_name,pkg_file)
      else
        puts "File "+pkg_file+" is not a bzipped file"
        exit
      end
    when /tar\.gz$|tgz$/
      if file_type =~ /gzip compressed data/
        app_pid = copy_tar(app_name,pkg_file)
      else
        puts "File "+pkg_file+" is not a gzipped file"
        exit
      end
    when /zip$/
      if file_type =~ /Zip archive/
        tmp_dir = unzip_app(app_name,pkg_file)
        app_pid = copy_app(app_name,tmp_dir,rem_ver)
      else
        puts "File "+pkg_file+" is not a ZIP file"
        exit
      end
    when /dmg$/
      if file_type =~ /data|VAX COFF/
        tmp_dir = attach_dmg(app_name,pkg_file)
        app_pid = copy_app(app_name,tmp_dir,rem_ver)
        detach_dmg(tmp_dir)
      else
        puts "File "+pkg_file+" is not a DMG file"
        exit
      end
    end
    if app_pid.match(/[0-9]/)
      start_app(app_name)
    end
  else
    puts "Package file "+pkg_file+" does not exist"
    exit
  end
  return
end

def fix_gatekeeper(app_name)
  app_type = get_app_type(app_name)
  if app_type.match(/app|util|run/)
    app_dir = get_app_dir(app_name)
    if File.directory?(app_dir)
      if $verbose == 1
        puts "Updating Gatekeeper and Quarantine information"
      end
      %x[sudo spctl --add --label "#{app_name}" "#{app_dir}"]
      %x[sudo spctl --enable --label "#{app_name}"]
      %x[sudo xattr -d -r com.apple.quarantine "#{app_dir}"]
    end
  else
    if $verbose == 1
      puts "Application "+app_name+" does not use Gatekeeper"
    end
  end
  return
end

def cleanup_old_files()
  if $verbose == 1
    puts "Cleaning up files older than "+$mtime+" days in "+$work_dir
  end
  if $work_dir =~ /[a-z]/
    %x[find #{$work_dir} -mtime +#{$mtime} -exec rm -rf '{}' \\;]
  end
end

def get_todays_date()
  todays_date = DateTime.now.to_s
  todays_date = DateTime.parse(todays_date).to_date
  return todays_date
end

def check_todays_date(loc_ver)
  todays_date = get_todays_date()
  if todays_date.to_time == loc_ver.to_time
    puts "Today's build is already installed"
    exit
  end
  return
end

def download_and_install_app(app_name)
  remove_crash(app_name)
  cleanup_old_files()
  loc_ver = get_loc_ver(app_name)
  rem_ver = get_rem_ver(app_name)
  if loc_ver.to_s.match(/Installed/)
    result = 0
  else
    if loc_ver.to_s.match(/-/) and !loc_ver.to_s.match(/beta/)
      check_todays_date(loc_ver)
    end
    result = compare_build_vers(loc_ver,rem_ver)
  end
  if result == 0
    pkg_url  = get_pkg_url(app_name)
    app_url  = get_app_url(app_name)
    pkg_file = download_app(app_name,app_url,pkg_url,rem_ver)
    install_app(app_name,pkg_file,rem_ver)
    fix_gatekeeper(app_name)
    post_install(app_name)
  end
  return
end

def remove_app(app_name)
  app_dir  = get_app_dir(app_name)
  app_type = get_app_type(app_name)
  if File.directory?(app_dir)
    if app_dir.match(/#{app_name}/) and !app_type.match(/bin/)
      if $verbose == 1
        puts "Removing "+app_dir
      end
      %x[sudo rm -rf "#{app_dir}"]
    end
  end
  return
end

def post_install(app_name)
  eval("do_#{app_name.downcase.gsub(/ |-/,'_')}_post_install(app_name)")
  return
end

def print_avail_pkgs()
  pkg_list = Dir.entries($pkg_dir)
  pkg_list.each do |file_name|
    if file_name =~ /rb$/
      spacer   = ""
      pkg_name = File.basename(file_name,".rb")
      app_name = eval("get_#{pkg_name}_app_name()")
      app_url  = eval("get_#{pkg_name}_app_url()")
      counter  = 20 - app_name.length
      counter.times do |x|
        spacer = spacer+" "
      end
      puts app_name+spacer+"[ "+app_url+" ]"
    end
  end
  return
end

begin
  opt  = Getopt::Std.getopts(options)
  used = 0
  options.gsub(/:/,"").each_char do |option|
    if opt[option]
      used = 1
    end
  end
  if used == 0
    print_usage
  end
rescue
  print_usage(options)
  exit
end

if opt["h"]
  print_usage(options)
end

if opt["V"]
  print_version()
end

if opt["v"]
  $verbose = 1
end

if !File.directory?($work_dir)
  if $verbose == 1
    puts "Creating directory "+$work_dir
  end
  Dir.mkdir($work_dir)
end

if opt["l"]
  app_name = opt['l']
  app_name = get_app_name(app_name)
  loc_ver  = get_loc_ver(app_name)
  puts loc_ver
  exit
end

if opt["q"]
  app_name = opt["q"]
  app_name = get_app_name(app_name)
  quit_app(app_name)
  exit
end

if opt["s"]
  app_name = opt["s"]
  app_name = get_app_name(app_name)
  start_app(app_name)
  exit
end

if opt["r"]
  app_name = opt["r"]
  app_name = get_app_name(app_name)
  rem_ver  = get_rem_ver(app_name)
  puts rem_ver
  exit
end

if opt["c"]
  app_name = opt["c"]
  app_name = get_app_name(app_name)
  loc_ver  = get_loc_ver(app_name)
  rem_ver  = get_rem_ver(app_name)
  compare_build_vers(loc_ver,rem_ver)
  exit
end

if opt["d"]
  app_name = opt["d"]
  app_url  = get_app_url(app_name)
  pkg_url  = get_pkg_url(app_name)
  rem_ver  = get_rem_ver(app_name)
  download_app(app_name,app_url,pkg_url,rem_ver)
  exit
end

if opt["g"]
  app_name = opt["g"]
  app_name = get_app_name(app_name)
  fix_gatekeeper(app_name)
  exit
end

if opt["p"]
  app_name = opt["p"]
  app_name = get_app_name(app_name)
  pkg_url  = get_pkg_url(app_name)
  puts pkg_url
  exit
end

if opt["u"]
  app_name = opt["u"]
  app_name = get_app_name(app_name)
  download_and_install_app(app_name)
end

if opt["i"]
  app_name = opt["i"]
  app_name = get_app_name(app_name)
  download_and_install_app(app_name)
end

if opt["z"]
  $verbose = 1
  cleanup_old_files()
end

if opt["Z"]
  $verbose = 1
  app_name = opt["Z"]
  app_name = get_app_name(app_name)
  remove_app(app_name)
end

if opt["C"]
  $verbose = 1
  app_name = opt["C"]
  app_name = get_app_name(app_name)
  remove_crash(app_name)
end

if opt["P"]
  $verbose = 1
  app_name = opt["P"]
  app_name = get_app_name(app_name)
  post_install(app_name)
end

if opt["a"]
  print_avail_pkgs()
  exit
end
