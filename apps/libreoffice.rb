#
# Routines for LibreOffice
#

def get_libreoffice_app_name()
  app_name = "LibreOffice"
  return app_name
end

def get_libreoffice_app_url()
  app_url = "http://dev-builds.libreoffice.org/pre-releases/mac/x86_64/"
  return app_url
end

def get_libreoffice_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[5]
  pkg_url = app_url+pkg_url
  return pkg_url
end

def get_libreoffice_rem_ver(app_url)
  pkg_url = get_libreoffice_pkg_url(app_url)
  rem_ver = File.basename(pkg_url)
  rem_ver = rem_ver.split(/_/)[1]
  return rem_ver
end

def get_libreoffice_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_libreoffice_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_libreoffice_post_install(app_name)
  return
end
