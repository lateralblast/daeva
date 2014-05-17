#!/usr/bin/env ruby -w
#
# Name:         daeva (Download and Automatically Enable Various Applications)
# Version:      0.0.5
# Release:      1
# License:      Open Source
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

# Variables

options  = "aC:c:d:ghi:l:p:r:vVzZ:"

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

$pkg_info["VLC"]    = "http://nightlies.videolan.org/build/macosx-intel/"
$pkg_info["WebKit"] = "http://nightly.webkit.org/builds/trunk/mac/1"

def print_version()
  puts
  file_array = IO.readlines $0
  version    = file_array.grep(/^# Version/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  packager   = file_array.grep(/^# Packager/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  name       = file_array.grep(/^# Name/)[0].split(":")[1].gsub(/^\s+/,'').chomp
  puts name+" v. "+version+" "+packager
  puts
end

def print_usage(options)
  puts
  puts "Usage: "+$0+" -["+options+"]"
  puts
  puts "-V:\tDisplay version information"
  puts "-h:\tDisplay usage information"
  puts "-v:\tVerbose output"
  puts "-d:\tDownload latest build but don't install"
  puts "-i:\tDownload and install latest build"
  puts "-l:\tGet local build date for application"
  puts "-r:\tGet remote build date for application"
  puts "-p:\tGet URL of download for latest package"
  puts "-c:\tCompare local and remote build dates"
  puts "-a:\tShow available packages"
  puts "-g:\tUpdate Gatekeeper and Quarantine information so application can run"
  puts "-z:\tClean up temporary directory (delete files older than "+$mtime+" days"
  puts "-Z:\tRemove existing application"
  puts "-C:\tRemove crash reporter file"
  puts
end

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

def get_app_name(app_name)
  app_file = $pkg_dir+"/"+app_name.downcase+".rb"
  if File.exist?(app_file)
    app_name = eval("get_#{app_name.downcase}_app_name()")
  else
    puts "Application "+app_name+" not found"
  end
  return app_name
end

def get_app_url(app_name)
  app_file = $pkg_dir+"/"+app_name.downcase+".rb"
  if File.exist?(app_file)
    app_url = eval("get_#{app_name.downcase}_app_url()")
  else
    puts "Application "+app_name+" not found"
  end
  return app_url
end

def get_app_dir(app_name)
  app_dir = "/Applications/"+app_name+".app"
  return app_dir
end

def get_loc_date(app_name)
  app_dir = get_app_dir(app_name)
  app_bin = app_dir+"/Contents/MacOS/"+app_name
  if File.directory?(app_dir)
    if File.exist?(app_bin)
      loc_date = File.mtime(app_bin)
      loc_date = DateTime.parse(loc_date.to_s).to_date
    else
      loc_date = "Not Installed"
      if $verbose == 1
        puts "Application "+app_bin+" does not exist"
      end
    end
  else
    loc_date = "Not Installed"
    if $verbose == 1
      puts "Directory "+app_dir+" does not exist"
    end
  end
  return loc_date
end

def get_rem_date(app_name)
  app_url  = eval("get_#{app_name.downcase}_app_url()")
  if $verbose == 1
    puts "Getting date of latest release from "+app_url
  end
  rem_date = eval("get_#{app_name.downcase}_rem_date(app_url)")
  if rem_date.to_s !~ /[0-9]/
    puts "Remote build date not found"
    exit
  end
  return rem_date
end

def compare_build_dates(loc_date,rem_date)
  if loc_date == "Not Installed"
    result = 0
  else
    if rem_date.to_time > loc_date.to_time
      result = 0
    else
      result = 1
    end
  end
  if $verbose == 1
    puts "Local build date:  "+loc_date.to_s
    puts "Remote build date: "+rem_date.to_s
    if result == 0
      puts "Remote version of build is newer than local"
    else
      puts "Local version of build is up to date"
    end
  end
  return result
end

def get_pkg_url(app_name)
  app_url  = get_app_url(app_name)
  case app_name.downcase
  when /vlc/
    pkg_url = app_url+"last"
  when /webkit/
    pkg_url = Net::HTTP.get(URI.parse(app_url))
    pkg_url  = URI.extract(pkg_url,"http")[0]
  end
  return pkg_url
end

def download_app(app_name,pkg_url,rem_date)
  case app_name.downcase
  when /vlc/
    suffix = "zip"
  when /webkit/
    suffix = "dmg"
  end
  pkg_file = $work_dir+"/"+app_name.downcase+"-"+rem_date.to_s+"."+suffix
  if !File.exist?(pkg_file)
    if $verbose == 1
      puts "Downloading "+pkg_url+" to "+pkg_file
    end
    %x[curl -o "#{pkg_file}" "#{pkg_url}"]
  else
    if $verbose == 1
      puts pkg_file+" already exists"
    end
  end
  return pkg_file
end

def unzip_app(zip_file)
  if File.exist?(zip_file)
    zip_test = %x[unzip -q -t #{zip_file} 2>&1]
    zip_dir  = File.dirname(zip_file)
  else
    puts "Zip file "+zip_file+" does not exist"
  end
  if zip_test =~ /No errors/
    if $verbose == 1
      %x[cd #{$work_dir} ; unzip -d #{zip_dir} -o #{zip_file}]
    else
      %x[cd #{$work_dir} ; unzip -d #{zip_dir} -q -o #{zip_file} 2>&1 /dev/null]
    end
  else
    puts "Zip file "+zip_file+" contains errors"
    exit
  end
  return zip_dir
end

def copy_app(app_name,tmp_dir)
  if File.directory?(tmp_dir)
    %x[cd #{tmp_dir} ; sudo cp -rp `find . -name #{app_name}.app` /Applications]
    if $verbose == 1
      puts "Copying Application from "+tmp_dir+" to /Application"
    end
  else
    puts "Directory "+tmp_dir+" does not exist "
    exit
  end
  return
end

def attach_dmg(app_name,pkg_file)
  tmp_dir = %x[sudo hdiutil attach #{pkg_file} |tail -1 |awk '{print $3}' ].chomp
  if tmp_dir !~ /[A-z]/
    tmp_dir = "/Volumes/"+app_name
  end
  return tmp_dir
end

def detach_dmg(tmp_dir)
  %x[hdiutil detach #{tmp_dir}]
  return
end

def install_app(app_name,pkg_file)
  if File.exist?(pkg_file)
    case pkg_file
    when /zip$/
      tmp_dir = unzip_app(pkg_file)
      copy_app(app_name,tmp_dir)
    when /dmg$/
      tmp_dir = attach_dmg(app_name,pkg_file)
      copy_app(app_name,tmp_dir)
      detach_dmg(tmp_dir)
    end
  else
    puts "Package file "+pkg_file+" does not exist"
    exit
  end
  return
end

def fix_gatekeeper(app_name)
  app_dir = get_app_dir(app_name)
  if $verbose == 1
    puts "Updating Gatekeeper and Quarantine information"
  end
  %x[sudo spctl --add --label "#{app_name}" "#{app_dir}"]
  %x[sudo spctl --enable --label "#{app_name}"]
  %x[sudo xattr -d -r com.apple.quarantine "#{app_dir}"]
  return
end

def cleanup_old_files()
  if $verbose == 1
    puts "Cleaning up files older than "+$mtime+" days in "+$work_dir
  end
  if $work_dir =~ /[a-z]/
    %x[find #{$work_dir} -mtime +#{$mtime} -exec rm '{}' \\;]
  end
end

def check_todays_date(loc_date)
  todays_date = DateTime.now.to_s
  todays_date = DateTime.parse(todays_date).to_date
  if todays_date.to_time == loc_date.to_time
    puts "Today's build is already installed"
    exit
  end
  return
end

def download_and_install_app(app_name)
  remove_crash(app_name)
  cleanup_old_files()
  loc_date = get_loc_date(app_name)
  rem_date = get_rem_date(app_name)
  if loc_date == "Not Installed"
    result = 0
  else
    check_todays_date(loc_date)
    result = compare_build_dates(loc_date,rem_date)
  end
  if result == 0
    pkg_url  = get_pkg_url(app_name)
    pkg_file = download_app(app_name,pkg_url,rem_date)
    install_app(app_name,pkg_file)
    fix_gatekeeper(app_name)
  end
  return
end

def remove_app(app_name)
  app_dir = get_app_dir(app_name)
  if File.directory?(app_dir)
    if $verbose == 1
      puts "Removing "+app_dir
    end
    %x[rm -rf #{app_dir}]
  end
  return
end

def print_avail_pkgs()
  pkg_list = Dir.entries($pkg_dir)
  pkg_list.each do |file_name|
    if file_name =~ /rb$/
      pkg_name = File.basename(file_name,".rb")
      app_name = eval("get_#{pkg_name}_app_name()")
      app_url  = eval("get_#{pkg_name}_app_url()")
      puts app_name+"\t[ "+app_url+" ]"
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
  $verbos  = 1
  app_name = opt['l']
  app_name = get_app_name(app_name)
  loc_date = get_loc_date(app_name)
  puts loc_date
  exit
end

if opt["r"]
  $verbos    = 1
  app_name = opt["r"]
  app_name = get_app_name(app_name)
  rem_date = get_rem_date(app_name)
  puts rem_date
  exit
end

if opt["c"]
  $verbose = 1
  app_name = opt["c"]
  app_name = get_app_name(app_name)
  loc_date = get_loc_date(app_name)
  rem_date = get_rem_date(app_name)
  compare_build_dates(loc_date,rem_date)
  exit
end

if opt["d"]
  $verbose = 1
  app_name = opt["d"]
  pkg_url  = get_pkg_url(app_name)
  rem_date = get_rem_date(app_name)
  download_app(app_name,pkg_url,rem_date)
  exit
end

if opt["g"]
  $verbose = 1
  app_name = get_app_name(app_name)
  fix_gatekeeper(app_name)
  exit
end

if opt["p"]
  $verbose = 1
  app_name = opt["p"]
  app_name = get_app_name(app_name)
  pkg_url  = get_pkg_url(app_name)
  puts pkg_url
  exit
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

if opt["a"]
  print_avail_pkgs()
  exit
end
