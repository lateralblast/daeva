#
# Routines for Firefox
#

def get_firefox_app_name()
  app_name = "Firefox"
  return app_name
end

def get_firefox_app_type()
  app_type = "app"
  return app_type
end

def get_firefox_app_url()
  app_url = "https://www.mozilla.org/en-US/firefox/new/"
  return app_url
end

def get_firefox_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/osx/)[0].split(/href="/)[4].split(/"/)[0].gsub(/amp;/,"")
  return pkg_url
end

def get_firefox_rem_ver(app_url)
  pkg_url = get_firefox_pkg_url(app_url)
  rem_ver = File.basename(pkg_url)
  rem_ver = rem_ver.split(/-/)[1]
  return rem_ver
end

def get_firefox_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_firefox_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_firefox_post_install(app_name)
  return
end
