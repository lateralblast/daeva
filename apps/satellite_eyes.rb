#
# Routines for Satellite Eyes
#

def get_satellite_eyes_app_name()
  app_name = "Satellite Eyes"
  return app_name
end

def get_satellite_eyes_app_type()
  app_type = "app"
  return app_type
end

def get_satellite_eyes_app_url()
  app_url = "http://www.macupdate.com/app/mac/46837/satellite-eyes"
  return app_url
end

def get_satellite_eyes_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_satellite_eyes_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_satellite_eyes_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_satellite_eyes_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_satellite_eyes_post_install(app_name,app_url)
  return
end
