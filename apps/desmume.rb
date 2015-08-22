#
# Routines for DeSmuMe
#

def get_desmume_app_name()
  app_name = "DeSmuMe"
  return app_name
end

def get_desmume_app_type()
  app_type = "app"
  return app_type
end

def get_desmume_app_url()
  app_url = "http://sourceforge.net/projects/desmume/?source=directory"
  return app_url
end

def get_desmume_pkg_url(app_name,app_url)
  rem_ver = get_desmume_rem_ver(app_name,app_url)
  pkg_url = "http://downloads.sourceforge.net/project/desmume/desmume/"+rem_ver+"/desmume-"+rem_ver+"-mac.dmg"
  return pkg_url
end

def get_desmume_rem_ver(app_name,app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/desmume-/)[1].split(/\.tar/)[0].split(/-/)[1]
  return rem_ver
end

def get_desmume_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_desmume_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_desmume_post_install(app_name,app_url)
  return
end
