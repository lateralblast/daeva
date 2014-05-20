#
# Routines for Adium
#

def get_adium_app_name()
  app_name = "Adium"
  return app_name
end

def get_adium_app_url()
  app_url = "https://adium.im/"
  return app_url
end

def get_adium_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split('"')[1]
  return pkg_url
end

def get_adium_rem_ver(app_url)
  rem_ver = get_adium_pkg_url(app_url)
  rem_ver = rem_ver.split("_")[1].split(".dmg")[0]
  return rem_ver
end

def get_adium_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_adium_loc_ver(app_name)
  loc_ver = get_app_date(app_name)
  return loc_ver
end

def do_adium_post_install(app_name)
  return
end
