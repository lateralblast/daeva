#
# Routines for Simple Comic
#

def get_simple_comic_app_name()
  app_name = "Simple Comic"
  return app_name
end

def get_simple_comic_app_url()
  app_url = "http://dancingtortoise.com/simplecomic/"
  return app_url
end

def get_simple_comic_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/zip/)[0].split(/"/)[3]
  return pkg_url
end

def get_simple_comic_rem_ver(app_url)
  pkg_url = get_simple_comic_pkg_url(app_url)
  rem_ver = File.basename(pkg_url,".zip")
  rem_ver = rem_ver.split(/_/)[1..2].join(".")
  return rem_ver
end

def get_simple_comic_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_simple_comic_loc_ver(app_name)
  loc_ver  = get_app_ver(app_name)
  min_ver  = get_min_ver(app_name)
  loc_ver  = loc_ver+"."+min_ver
  return loc_ver
end

def do_simple_comic_post_install(app_name)
  return
end
