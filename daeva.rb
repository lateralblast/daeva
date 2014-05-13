#!/usr/bin/env ruby -w
#
# Name:         daeva (Download and Automatically Enable nightly VLC for Apple)
# Version:      0.0.2
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

require 'getopt/std'
require 'net/http'
require 'uri'
require 'date'

options   = "cdghilrvVzZ"
vlc_url   = "http://nightlies.videolan.org/build/macosx-intel/"
vlc_app   = "/Applications/VLC.app"
vlc_bin   = vlc_app+"/Contents/MacOS/VLC"
vlc_label = "VLC"

$verbose  = 0
$work_dir = "/tmp/daeva"
$mtime    = "7"

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
  puts "-l:\tGet local build date"
  puts "-r:\tGet remote build date"
  puts "-c:\tCompare local and remote  build dates"
  puts "-g:\tUpdate Gatekeeper and Quarantine information so application can run"
  puts "-z:\tClean up temporary directory (delete files older than "+$mtime+" days"
  puts "-Z:\tRemove existing VLC application"
  puts
end

def get_local_build_date(vlc_bin)
  if File.exist?(vlc_bin)
    local_build_date = %x[#{vlc_bin} --version 2>&1 |grep buildbot |cut -f2 -d'(' |cut -f1 -d')']
    local_build_date = DateTime.parse(local_build_date).to_date
  else
    local_build_date = "Not Installed"
  end
  return local_build_date
end

def get_remote_build_date(vlc_url)
  if $verbose == 1
    puts "Getting date of latest release from "+vlc_url
  end
  remote_build_date = Net::HTTP.get(URI.parse(vlc_url)).split("\n").grep(/last/)[0].split(/\s+/)[6..7].join(" ")
  remote_build_date = DateTime.parse(remote_build_date).to_date
  return remote_build_date
end

def compare_build_dates(local_build_date,remote_build_date)
  if local_build_date == "Not Installed"
    result = 0
  else
    if remote_build_date.to_time > local_build_date.to_time
      result = 0
    else
      result = 1
    end
  end
  if $verbose == 1
    puts "Local build date:  "+local_build_date.to_s
    puts "Remote build date: "+remote_build_date.to_s
    if result == 0
      puts "Remote version of build is newer than local"
    else
      puts "Local version of build is up to date"
    end
  end
  return result
end

def get_actual_url(vlc_url)
  actual_url = html_doc.scan("last")
  puts actual_url
  exit
  if $verbose == 1
    puts "URL:      "+vlc_url
    puts "Redirect: "+actual_url
  end
  exit
  return actual_url
end

def download_vlc(vlc_url,remote_build_date)
  zip_url  = vlc_url+"last"
  zip_file = $work_dir+"/vlc-nightly-"+remote_build_date.to_s+".zip"
  if !File.exist?(zip_file)
    if $verbose == 1
      puts "Downloading "+zip_url+" to "+zip_file
    end
    %x[curl -o "#{zip_file}" "#{zip_url}"]
  else
    if $verbose == 1
      puts zip_file+" already exists"
    end
  end
  return zip_file
end

def unzip_vlc(zip_file)
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

def copy_vlc(zip_dir)
  if File.directory?(zip_dir)
    %x[cd #{zip_dir} ; cp -rp `find . -name VLC.app` /Applications]
  else
    puts "Directory "+zip_dir+" does not exist "
    exit
  end
end

def install_vlc(zip_file)
  if File.exist?(zip_file)
    zip_dir = unzip_vlc(zip_file)
    copy_vlc(zip_dir)
  else
    puts "Zip file "+zip_file+" does not exist"
    exit
  end
  return
end

def fix_gatekeeper(vlc_app,vlc_label)
  if $verbose == 1
    puts "Updating Gatekeeper and Quarantine information"
  end
  %x[sudo spctl --add --label "#{vlc_label}" "#{vlc_app}"]
  %x[sudo spctl --enable --label "#{vlc_label}"]
  %x[sudo xattr -d -r com.apple.quarantine "#{vlc_app}"]
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

def check_todays_date(local_build_date)
  todays_date      = DateTime.now.to_s
  todays_date      = DateTime.parse(todays_date).to_date
  if todays_date.to_time == local_build_date.to_time
    puts "Today's build is already installed"
    exit
  end
  return
end

def download_and_install_vlc(vlc_app,vlc_bin,vlc_label,vlc_url)
  cleanup_old_files()
  local_build_date = get_local_build_date(vlc_bin)
  check_todays_date(local_build_date)
  remote_build_date = get_remote_build_date(vlc_url)
  result = compare_build_dates(local_build_date,remote_build_date)
  if result == 0
    zip_file = download_vlc(vlc_url,remote_build_date)
    install_vlc(zip_file)
    fix_gatekeeper(vlc_app,vlc_label)
  end
  return
end

def remove_vlc(vlc_app)
  if vlc_app =~ /[A-z]/
    if File.directory?(vlc_app)
      if $verbose == 1
        puts "Removing "+vlc_app
      end
      %x[rm -rf #{vlc_app}]
    end
  end
  return
end

begin
  opt = Getopt::Std.getopts(options)
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
  local_build_date = get_local_build_date(vlc_bin)
  puts local_build_date
  exit
end

if opt["r"]
  remote_build_date = get_remote_build_date(vlc_url)
  puts remote_build_date
  exit
end

if opt["c"]
  $verbose = 1
  compare_build_dates(vlc_url,vlc_bin)
  exit
end

if opt["d"]
  $verbose = 1
  remote_build_date = get_remote_build_date(vlc_url)
  download_vlc(vlc_url,remote_build_date)
  exit
end

if opt["g"]
  $verbose = 1
  fix_gatekeeper(vlc_app,vlc_label)
  exit
end

if opt["i"]
  download_and_install_vlc(vlc_app,vlc_bin,vlc_label,vlc_url)
end

if opt["z"]
  $verbose = 1
  cleanup_old_files()
end

if opt["Z"]
  $verbose = 1
  remove_vlc(vlc_app)
end
