#
# Routines for OpenZFS
#

def get_openzfs_app_name()
  app_name = "OpenZFS"
  return app_name
end

def get_openzfs_app_type()
  app_type = "app"
  return app_type
end

def get_openzfs_app_url()
  app_url = "http://www.macupdate.com/app/mac/51788/openzfs-on-os-x"
  return app_url
end

def get_openzfs_pkg_url(app_name,app_url)
  pkg_ver = get_rem_ver(app_name)
  pkg_url = "http://openzfsonosx.org/w/images/0/0d/OpenZFS_on_OS_X_"+pkg_ver+".dmg"
  return pkg_url
end

def get_openzfs_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_openzfs_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_openzfs_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_openzfs_post_install(app_name,app_url)
  return
end
