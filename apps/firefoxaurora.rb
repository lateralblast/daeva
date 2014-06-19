#
# Routines for firefoxaurora
#

def get_firefoxaurora_app_name()
  app_name = "FirefoxAurora"
  return app_name
end

def get_firefoxaurora_app_url()
  app_url = "http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-mozilla-aurora/"
  return app_url
end

def get_firefoxaurora_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[7]
  pkg_url = app_url+pkg_url
  return pkg_url
end

def get_firefoxaurora_rem_ver(app_url)
  pkg_url = get_firefoxaurora_pkg_url(app_url)
  rem_ver = File.basename(pkg_url)
  rem_ver = rem_ver.split(/-/)[1].split(/\./)[0..1].join(".")
  return rem_ver
end

def get_firefoxaurora_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_firefoxaurora_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.gsub(/Aurora /,"")
  return loc_ver
end

def do_firefoxaurora_post_install(app_name)
  return
end
