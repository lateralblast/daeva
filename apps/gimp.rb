#
# Routines for GIMP
#

def get_gimp_app_name()
  app_name = "GIMP"
  return app_name
end

def get_gimp_app_type()
  app_type = "app"
  return app_type
end

def get_gimp_app_url()
  app_url = "http://download.gimp.org/pub/gimp/v2.8/osx/experimental/"
  return app_url
end

def get_gimp_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split(/\n/).grep(/dmg/)[0].split(/"/)[5]
  pkg_url = app_url+pkg_url
  return pkg_url
end

def get_gimp_rem_ver(app_name,app_url)
  rem_date = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/\s+/)[6]
  rem_date = DateTime.parse(rem_date).to_date
  return rem_date
end

def get_gimp_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_gimp_loc_ver(app_name)
  loc_ver = get_app_date(app_name)
  return loc_ver
end

def do_gimp_post_install(app_name,app_url)
  return
end
