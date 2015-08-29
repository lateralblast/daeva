#
# Routines for VirtualBox
#

def get_virtualbox_app_name()
  app_name = "VirtualBox"
  return app_name
end

def get_virtualbox_app_type()
  app_type = "pkg"
  return app_type
end

def get_virtualbox_app_url()
  app_url = "http://download.virtualbox.org/virtualbox/"
  return app_url
end

def get_virtualbox_pkg_url(app_name,app_url)
  rem_ver  = get_virtualbox_rem_ver(app_name,app_url)
  wiki_url = "https://www.virtualbox.org/wiki/Downloads"
  pkg_url  = Net::HTTP.get(URI.parse(wiki_url)).to_s.split("\n").grep(/OSX/)[0].chomp.split(/"/)[3]
  return pkg_url
end

def get_virtualbox_rem_ver(app_name,app_url)
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

def do_virtualbox_post_install(app_name,app_url)
  loc_ver  = get_virtualbox_loc_ver(app_name)
  if loc_ver
    top_url  = "http://download.virtualbox.org/virtualbox/"+loc_ver
    pkg_file = "Oracle_VM_VirtualBox_Extension_Pack-"+loc_ver+".vbox-extpack"
    pkg_url  = top_url+"/"+pkg_file
    pkg_file = $work_dir+"/"+pkg_file
    get_pkg_file(app_name,app_url,pkg_url,pkg_file)
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
