#
# Routines for VirtualBox
#

def get_virtualbox_app_name()
  app_name = "VirtualBox"
  return app_name
end

def get_virtualbox_app_url()
  app_url = "http://download.virtualbox.org/virtualbox/"
  return app_url
end

def get_virtualbox_pkg_url(app_url)
  rem_ver = get_virtualbox_rem_ver(app_url)
  base_url = app_url+rem_ver+"/"
  pkg_name = Net::HTTP.get(URI.parse(base_url)).split("\n").grep(/OSX/)[0].chomp.split(/"/)[1]
  sun_url  = "http://dlc.sun.com.edgesuite.net/virtualbox/"
  pkg_url  = sun_url+rem_ver+"/"+pkg_name
  return pkg_url
end

def get_virtualbox_rem_ver(app_url)
  ver_url = app_url+"LATEST.TXT"
  rem_ver = Net::HTTP.get(URI.parse(ver_url)).chomp
  return rem_ver
end

def get_virtualbox_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_virtualbox_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_virtualbox_post_install(app_name)
  loc_ver  = get_app_ver(app_name)
  sun_url  = "http://dlc.sun.com.edgesuite.net/virtualbox/"
  pkg_file = "Oracle_VM_VirtualBox_Extension_Pack-"+loc_ver+".vbox-extpack"
  pkg_url  = sun_url+loc_ver+"/"+pkg_file
  pkg_file = $work_dir+"/"+pkg_file
  get_pkg_file(pkg_url,pkg_file)
  if File.exist?(pkg_file)
    vbox_bin = "/Applications/"+app_name+".app/Contents/MacOS/VboxManage"
    if File.exist?(vbox_bin)
      if $verbose == 1
        puts "Installing VirtualBox Extensions Pack"
      end
      %x[sudo #{vbox_bin} extpack install #{pkg_file}]
    end
  else
    puts "File "+pkg_file+" does not exist"
  end
  return
end
