#
# Routines for XQuartz
#

def get_xquartz_app_name()
  app_name = "XQuartz"
  return app_name
end

def get_xquartz_app_type()
  app_type = "util"
  return app_type
end

def get_xquartz_app_url()
  app_url = "http://xquartz.macosforge.org/trac/wiki"
  return app_url
end

def get_xquartz_pkg_url(app_name,app_url)
  rem_ver = get_xquartz_rem_ver(app_url)
  pkg_url = "http://xquartz-dl.macosforge.org/SL/XQuartz-"+rem_ver+".dmg"
  return pkg_url
end

def get_xquartz_rem_ver(app_name,app_url)
  branch  = "Development"
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/#{branch}/)[0].split(/>/)[3].split(/</)[0]
  return rem_ver
end

def get_xquartz_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_xquartz_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_xquartz_post_install(app_name)
  return
end
