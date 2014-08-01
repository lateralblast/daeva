#
# Routines for TinkerTool
#

def get_tinkertool_app_name()
  app_name = "TinkerTool"
  return app_name
end

def get_tinkertool_app_type()
  app_type = "app"
  return app_type
end

def get_tinkertool_app_url()
  app_url = "http://www.bresink.com/osx/0TinkerTool/download.php"
  return app_url
end

def get_tinkertool_pkg_url(app_name,app_url)
  pkg_url = get_tinkertool_app_url()
  return pkg_url
end

def get_tinkertool_rem_ver(app_name,app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/Build/)[0]
  maj_ver = rem_ver.split(/>/)[1].split(/ \(/)[0]
  min_ver = rem_ver.split(/Build /)[1].split(/\)/)[0]
  rem_ver = maj_ver+"."+min_ver
  return rem_ver
end

def get_tinkertool_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_tinkertool_loc_ver(app_name)
  maj_ver = get_app_ver(app_name)
  maj_ver = maj_ver.split(/\s+/)[1].split(/,/)[0]
  min_ver = get_min_ver(app_name)
  loc_ver = maj_ver+"."+min_ver
  return loc_ver
end

def do_tinkertool_post_install(app_name)
  return
end
