#
# Routines for Calibre
#

def get_calibre_app_name()
  app_name = "Calibre"
  return app_name
end

def get_calibre_app_type()
  app_type = "app"
  return app_type
end

def get_calibre_app_url()
  app_url = "http://calibre-ebook.com/download_osx"
  return app_url
end

def get_calibre_pkg_url(app_name,app_url)
  pkg_url = "http://status.calibre-ebook.com/dist/osx32"
  return pkg_url
end

def get_calibre_rem_ver(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/Alternate/).join.split('"')[7]
  rem_ver = File.basename(pkg_url)
  rem_ver = rem_ver.split(/-/)[1].split(/\./)[0..2].join(".")
  return rem_ver
end

def get_calibre_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_calibre_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_calibre_post_install(app_name)
  return
end
