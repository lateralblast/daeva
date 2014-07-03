#
# Routines for Google Chrome
#

def get_google_chrome_app_name()
  app_name = "Google Chrome"
  return app_name
end

def get_google_chrome_app_type()
  app_type = "app"
  return app_type
end

def get_google_chrome_app_url()
  app_url = "http://www.macupdate.com/app/mac/32956/google-google_chrome"
  return app_url
end

def get_google_chrome_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[3]
  pkg_url = "http://www.macupdate.com"+pkg_url
  return pkg_url
end

def get_google_chrome_rem_ver(app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/appversinfo/)[0].split(/<\/span>/)[1].split(/>/)[1]
  return rem_ver
end

def get_google_chrome_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_google_chrome_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split(/,/)[0]
  return loc_ver
end

def do_google_chrome_post_install(app_name)
  return
end
