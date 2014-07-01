#
# Routines for VirtualBox
#

def get_virtualbox_app_name()
  app_name = "VirtualBox"
  return app_name
end

def get_virtualbox_app_type()
  app_type = "app"
  return app_type
end

def get_virtualbox_app_url()
  app_url = "http://download.virtualbox.org/virtualbox/"
  return app_url
end

def get_virtualbox_pkg_url(app_url)
  rem_ver  = get_virtualbox_rem_ver(app_url)
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
  loc_ver = loc_ver.split(/,/)[0].gsub(/[A-z]/,"").gsub(/ /,"")
  return loc_ver
end

def do_virtualbox_post_install(app_name)
  loc_ver  = get_virtualbox_loc_ver(app_name)
  if loc_ver
    sun_url  = "http://dlc.sun.com.edgesuite.net/virtualbox/"
    pkg_file = "Oracle_VM_VirtualBox_Extension_Pack-"+loc_ver+".vbox-extpack"
    pkg_url  = sun_url+loc_ver+"/"+pkg_file
    pkg_file = $work_dir+"/"+pkg_file
    get_pkg_file(pkg_url,pkg_file)
    if File.exist?(pkg_file)
      app_dir  = "/Applications/"+app_name+".app"
      vbox_bin = app_dir+"/Contents/MacOS/VboxManage"
      if File.exist?(vbox_bin)
        if $verbose == 1
          puts "Installing VirtualBox Extensions Pack"
          puts "Changing ownership to root"
        end
        %x[sudo chown -R root #{app_dir}]
        %x[sudo #{vbox_bin} extpack install #{pkg_file}]
      end
    else
      puts "File "+pkg_file+" does not exist"
    end
  else
    puts "Application "+app_name+" did not install"
  end
  return
end
