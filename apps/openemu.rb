#
# Routines for OpenEmu
#

def get_openemu_app_name()
  app_name = "OpenEmu"
  return app_name
end

def get_openemu_app_type()
  app_type = "app"
  return app_type
end

def get_openemu_app_url()
  app_url = "http://openemu.org/"
  return app_url
end

def get_openemu_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/zip/)[1].split(/"/)[1]
  return pkg_url
end

def get_openemu_rem_ver(app_name,app_url)
  pkg_url = get_openemu_pkg_url(app_name,app_url)
  rem_ver = File.basename(pkg_url,".zip").split(/_/)[1].split(/-/)[0]
  return rem_ver
end

def get_openemu_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_openemu_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_openemu_post_install(app_name,app_url)
  return
end
