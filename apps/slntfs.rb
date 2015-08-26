#
# Routines for SL-NTFS 
#

def get_sl_ntfs_app_name()
  app_name = "SLNTFS"
  return app_name
end

def get_slntfs_app_name()
  get_sl_ntfs_app_name()
end

def get_sl_ntfs_app_type()
  app_type = "pkg"
  return app_type
end

def get_slntfs_app_type()
  get_sl_ntfs_app_type()
end

def get_sl_ntfs_app_url()
  app_url = "http://www.macupdate.com/app/mac/33603/sl-ntfs"
  return app_url
end

def get_slntfs_app_url()
  get_sl_ntfs_app_url()
end

def get_sl_ntfs_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_slntfs_pkg_url(app_name,app_url)
  get_sl_ntfs_pkg_url(app_name,app_url)
end

def get_sl_ntfs_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_slntfs_rem_ver(app_name,app_url)
  get_sl_ntfs_rem_ver(app_name,app_url)
end

def get_sl_ntfs_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_slntfs_pkg_type()
  get_sl_ntfs_pkg_type()
end

def get_sl_ntfs_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def get_slntfs_loc_ver(app_name)
  get_sl_ntfs_loc_ver(app_name)
end

def do_sl_ntfs_post_install(app_name,app_url)
  return
end

def do_slntfs_post_install(app_name,app_url)
  do_sl_ntfs_post_install(app_name,app_url)
end
