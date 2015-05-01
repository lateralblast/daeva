#
# Routines for harvest
#

def get_harvest_app_name()
  app_name = "Harvest"
  return app_name
end

def get_harvest_app_type()
  app_type = "app"
  return app_type
end

def get_harvest_app_url()
  app_url = "http://www.macupdate.com/app/mac/42328/harvest"
  return app_url
end

def get_harvest_pkg_url(app_name,app_url)
  pkg_url = "https://www.getharvest.com/harvest/mac/Harvest.zip"
  return pkg_url
end

def get_harvest_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_harvest_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_harvest_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_harvest_post_install(app_name,app_url)
  return
end
