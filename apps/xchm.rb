#
# Routines for xCHM
#

def get_xchm_app_name()
  app_name = "xCHM"
  return app_name
end

def get_xchm_app_type()
  app_type = "app"
  return app_type
end

def get_xchm_app_url()
  app_url = "http://sourceforge.net/projects/xchm/files/xCHM%20for%20Mac%20OS/"
  return app_url
end

def get_xchm_pkg_url(app_name,app_url)
  rem_ver = get_xchm_rem_ver(app_name,app_url)
  pkg_url = "http://downloads.sourceforge.net/project/xchm/xCHM%20for%20Mac%20OS/xchm-"+rem_ver+"/xchm-"+rem_ver+".dmg"
  return pkg_url
end

def get_xchm_rem_ver(app_name,app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/xchm-/)[2].split('"')[1].split("-")[1]
  return rem_ver
end

def get_xchm_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_xchm_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split(",")[0].split(" ")[2]
  return loc_ver
end

def do_xchm_post_install(app_name)
  return
end
