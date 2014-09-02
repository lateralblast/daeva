#
# Routines for WineBottler
#

def get_winebottler_app_name()
  app_name = "WineBottler"
  return app_name
end

def get_winebottler_app_type()
  app_type = "app"
  return app_type
end

def get_winebottler_app_url()
  app_url = "http://www.macupdate.com/app/mac/33367/winebottler"
  return app_url
end

def get_winebottler_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_winebottler_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_winebottler_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_winebottler_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_winebottler_post_install(app_name,app_url)
  return
end
