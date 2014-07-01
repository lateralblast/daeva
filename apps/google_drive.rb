#
# Routines for Google Drive
#

def get_google_drive_app_name()
  app_name = "Google Drive"
  return app_name
end

def get_google_drive_app_type()
  app_type = "app"
  return app_type
end

def get_google_drive_app_url()
  app_url = "http://www.macupdate.com/app/mac/42735/google-drive"
  return app_url
end

def get_google_drive_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split(/\n/).grep(/dmg/)[0].split(/"/)[3]
  pkg_url = "http://www.macupdate.com"+pkg_url
  return pkg_url
end

def get_google_drive_rem_ver(app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split(/\n/).grep(/Version/)[0].gsub(/ /,"").split(/Version/)[1].split(/:/)[0]
  return rem_ver
end

def get_google_drive_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_google_drive_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_google_drive_post_install(app_name)
  return
end
