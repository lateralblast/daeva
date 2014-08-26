#
# Routines for OpenOffice
#

def get_openoffice_app_name()
  app_name = "OpenOffice"
  return app_name
end

def get_openoffice_app_type()
  app_type = "app"
  return app_type
end

def get_openoffice_app_url()
  aoo_ver = "4.1.0"
  app_url = "http://ftp.mirror.aarnet.edu.au/pub/apache/openoffice/"+aoo_ver+"/binaries/en-US/"
  return app_url
end

def get_openoffice_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[5]
  pkg_url = app_url+pkg_url
  return pkg_url
end

def get_openoffice_rem_ver(app_name,app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/\s+/)[6]
  rem_ver = DateTime.parse(rem_ver.to_s).to_date
  return rem_ver
end

def get_openoffice_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_openoffice_loc_ver(app_name)
  app_dir  = get_app_dir(app_name)
  app_bin  = app_dir+"/Contents/MacOS/soffice"
  if File.exist?(app_bin)
    app_date = File.mtime(app_bin)
    loc_ver  = DateTime.parse(app_date.to_s).to_date
  else
    loc_ver = "Not Installed"
  end
  return loc_ver
end

def do_openoffice_post_install(app_name,app_url)
  return
end
