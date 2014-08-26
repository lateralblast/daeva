#
# Routines for kid3
#

def get_kid3_app_name()
  app_name = "kid3"
  return app_name
end

def get_kid3_app_type()
  app_type = "app"
  return app_type
end

def get_kid3_app_url()
  app_url = "http://www.macupdate.com/app/mac/49515/kid3"
  return app_url
end

def get_kid3_pkg_url(app_name,app_url)
  pkg_type = get_kid3_pkg_type()
  rem_ver  = get_kid3_rem_ver(app_name,app_url)
  pkg_url  = app_url+"-"+rem_ver+"-darwin."+pkg_type
  return pkg_url
end

def get_kid3_rem_ver(app_name,app_url)
  rem_ver = "3.1.0"
  return rem_ver
end

def get_kid3_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_kid3_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_kid3_post_install(app_name,app_url)
  return
end
