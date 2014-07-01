#
# Routines for Picasa
#

def get_picasa_app_name()
  app_name = "Picasa"
  return app_name
end

def get_picasa_app_url()
  app_url = "http://www.macupdate.com/app/mac/30131/picasa"
  return app_url
end

def get_picasa_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[3]
  pkg_url = "http://www.macupdate.com"+pkg_url
  return pkg_url
end

def get_picasa_rem_ver(app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/appversinfo/)[0].split(/<\/span>/)[1].split(/>/)[1]
  return rem_ver
end

def get_picasa_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_picasa_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split(/,/)[0]
  return loc_ver
end

def do_picasa_post_install(app_name)
  return
end
