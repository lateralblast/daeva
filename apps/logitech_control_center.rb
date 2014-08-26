#
# Routines for Logitech Control Center
#

def get_logitech_control_center_app_name()
  app_name = "Logitech Control Center"
  return app_name
end

def get_logitech_control_center_app_type()
  app_type = "prefPane"
  return app_type
end

def get_logitech_control_center_app_url()
  app_url = "http://www.macupdate.com/app/mac/8154/logitech-control-center"
  return app_url
end

def get_logitech_control_center_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_logitech_control_center_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_logitech_control_center_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_logitech_control_center_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split("\n")[0].chomp
  return loc_ver
end

def do_logitech_control_center_post_install(app_name,app_url)
  return
end
