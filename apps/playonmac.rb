#
# Routines for PlayOnMac
#

def get_playonmac_app_name()
  app_name = "PlayOnMac"
  return app_name
end

def get_playonmac_app_type()
  app_type = "app"
  return app_type
end

def get_playonmac_app_url()
  app_url = "http://www.playonmac.com/en"
  return app_url
end

def get_playonmac_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[1]
  return pkg_url
end

def get_playonmac_rem_ver(app_name,app_url)
  pkg_url = get_playonmac_pkg_url(app_name,app_url)
  rem_ver = File.basename(pkg_url,".dmg").split("_")[1]
  return rem_ver
end

def get_playonmac_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_playonmac_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_playonmac_post_install(app_name,app_url)
  return
end
