#
# Routines for Thunderbird
#

def get_thunderbird_app_name()
  app_name = "Thunderbird"
  return app_name
end

def get_thunderbird_app_type()
  app_type = "app"
  return app_type
end

def get_thunderbird_app_url()
  app_url = "http://www.macupdate.com/app/mac/11942/thunderbird"
  return app_url
end

def get_thunderbird_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[3]
  pkg_url = "http://www.macupdate.com"+pkg_url
  return pkg_url
end

def get_thunderbird_rem_ver(app_url)
  pkg_url = get_thunderbird_pkg_url(app_url)
  rem_ver = File.basename(pkg_url,".dmg")
  rem_ver = rem_ver.split(/-|%20/)[1]
  return rem_ver
end

def get_thunderbird_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_thunderbird_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_thunderbird_post_install(app_name)
  return
end
