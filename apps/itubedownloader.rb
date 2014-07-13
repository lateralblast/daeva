#
# Routines for iTubeDownloader
#

def get_itubedownloader_app_name()
  app_name = "iTubeDownloader"
  return app_name
end

def get_itubedownloader_app_type()
  app_type = "app"
  return app_type
end

def get_itubedownloader_app_url()
  app_url = "http://www.macupdate.com/app/mac/30131/itubedownloader"
  return app_url
end

def get_itubedownloader_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_itubedownloader_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_itubedownloader_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_itubedownloader_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split(/,/)[0]
  return loc_ver
end

def do_itubedownloader_post_install(app_name)
  return
end
