#
# Routines for Transmission
#

def get_transmission_app_name()
  app_name = "Transmission"
  return app_name
end

def get_transmission_app_type()
  app_type = "app"
  return app_type
end

def get_transmission_app_url()
  app_url = "http://www.macupdate.com/app/mac/19378/transmission"
  return app_url
end

def get_transmission_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_transmission_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_transmission_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_transmission_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split(/ /)[0].gsub(/\+/,"")
  return loc_ver
end

def do_transmission_post_install(app_name)
  return
end
