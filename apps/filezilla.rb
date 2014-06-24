#
# Routines for FileZilla
#

def get_filezilla_app_name()
  app_name = "FileZilla"
  return app_name
end

def get_filezilla_app_url()
  app_url = "http://www.macupdate.com/app/mac/25092/filezilla"
  return app_url
end

def get_filezilla_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/macosx/)[0].split(/"/)[3]
  pkg_url = "http://www.macupdate.com"+pkg_url
  return pkg_url
end

def get_filezilla_rem_ver(app_url)
  pkg_url = get_filezilla_pkg_url(app_url)
  rem_ver = pkg_url.split(/_/)[1]
  return rem_ver
end

def get_filezilla_pkg_type()
  pkg_type = "tar.bz2"
  return pkg_type
end

def get_filezilla_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split(/ /)[1].gsub(/,/,"")
  return loc_ver
end

def do_filezilla_post_install(app_name)
  return
end
