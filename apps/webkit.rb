#
# Routines for WebKit
#

def get_webkit_app_name()
  app_name = "WebKit"
  return app_name
end

def get_webkit_app_url()
  app_url = "http://nightly.webkit.org/builds/trunk/mac/1"
  return app_url
end

def get_webkit_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url))
  pkg_url = URI.extract(pkg_url,"http")[0]
  return pkg_url
end

def get_webkit_rem_ver(app_url)
  rem_date = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/date/)[0].split(/>/)[1].split(/</)[0]
  rem_date = DateTime.parse(rem_date).to_date
  return rem_date
end

def get_webkit_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_webkit_loc_ver(app_name)
  loc_ver = get_app_date(app_name)
  return loc_ver
end

def do_webkit_post_install(app_name)
  return
end
