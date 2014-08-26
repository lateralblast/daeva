#
# Routines for Security Growler
#

def get_security_growler_app_name()
  app_name = "Security Growler"
  return app_name
end

def get_security_growler_app_type()
  app_type = "app"
  return app_type
end

def get_security_growler_app_url()
  app_url = "http://www.macupdate.com/app/mac/51503/security-growler"
  return app_url
end

def get_security_growler_pkg_url(app_name,app_url)
  pkg_url = get_macupdate_url(app_name,app_url)
  return pkg_url
end

def get_security_growler_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  return rem_ver
end

def get_security_growler_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_security_growler_loc_ver(app_name)
  app_dir   = get_app_dir(app_name)
  app_pfile = app_dir+"/Contents/Info.plist"
  if File.exist?(app_pfile)
    loc_ver  = %x[strings "#{app_pfile}" |grep SecurityGrowler].chomp
    loc_ver  = loc_ver.split(/_/)[0].split(/0S/)[1]
  else
    loc_ver = "Not Installed"
  end
  return loc_ver
end

def do_security_growler_post_install(app_name,app_url)
  add_login_item(app_name)
  return
end
