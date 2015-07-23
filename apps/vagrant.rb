#
# Routines for vagrant
#

def get_vagrant_app_name()
  app_name = "Vagrant"
  return app_name
end

def get_vagrant_app_type()
  app_type = "pkg"
  return app_type
end

def get_vagrant_app_url()
  app_url = "http://www.macupdate.com/app/mac/49997/vagrant"
  return app_url
end

def get_vagrant_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_vagrant_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_vagrant_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_vagrant_loc_ver(app_name)
  loc_bin = "/opt/vagrant/bin/vagrant"
  if File.exist?(loc_bin)
    loc_ver = %x[#{loc_bin} --version |awk '{print $2}'].chomp
  else
    loc_ver = "0"
  end
  return loc_ver
end

def do_vagrant_post_install(app_name,app_url)
  return
end
