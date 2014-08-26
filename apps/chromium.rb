#
# Routines for Chromium
#

def get_chromium_app_name()
  app_name = "Chromium"
  return app_name
end

def get_chromium_app_type()
  app_type = "app"
  return app_type
end

def get_chromium_app_url()
  app_url = "https://download-chromium.appspot.com/"
  return app_url
end

def get_chromium_pkg_url(app_name,app_url)
  pkg_url = "https://download-chromium.appspot.com/dl/Mac"
  pkg_url = Net::HTTP.get_response(URI.parse(pkg_url))['location']
  return pkg_url
end

def get_chromium_rem_ver(app_name,app_url)
  rem_date = get_todays_date()
  return rem_date
end

def get_chromium_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_chromium_loc_ver(app_name)
  loc_ver = get_app_date(app_name)
  return loc_ver
end

def do_chromium_post_install(app_name,app_url)
  return
end
