#
# Routines for Simple Comic
#

def get_simple_comic_app_name()
  app_name = "Simple Comic"
  return app_name
end

def get_simple_comic_app_type()
  app_type = "app"
  return app_type
end

def get_simple_comic_app_url()
  app_url = "http://www.macupdate.com/app/mac/21987/simple-comic"
  return app_url
end

def get_simple_comic_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_simple_comic_rem_ver(app_name,app_url)
  rem_ver = "1.7.251"
  return rem_ver
end

def get_simple_comic_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_simple_comic_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.gsub(/ RC2/,".251")
  return loc_ver
end

def do_simple_comic_post_install(app_name,app_url)
  return
end
