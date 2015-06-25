#
# Routines for Node
#

def get_node_app_name()
  app_name = "node"
  return app_name
end

def get_node_app_type()
  app_type = "pkg"
  return app_type
end

def get_node_app_url()
  app_url = "https://nodejs.org/download/"
  return app_url
end

def get_node_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/pkg/)[0].split(/"/)[1]
  return pkg_url
end

def get_node_rem_ver(app_name,app_url)
  rem_ver = get_pkg_url(app_name)
  rem_ver = rem_ver.split(/\//)[4].gsub(/v/,"")
  return rem_ver
end

def get_node_pkg_type()
  pkg_type = "pkg"
  return pkg_type
end

def get_node_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_node_post_install(app_name,app_url)
  return
end
