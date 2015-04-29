#
# Routines for privatetunnel
#

def get_privatetunnel_app_name()
  app_name = "PrivateTunnel"
  return app_name
end

def get_privatetunnel_app_type()
  app_type = "mpkg"
  return app_type
end

def get_privatetunnel_app_url()
  app_url = "https://openvpn.net/"
  return app_url
end

def get_privatetunnel_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/href="/)[1].split(/"/)[0]
  return pkg_url
end

def get_privatetunnel_rem_ver(app_name,app_url)
  pkg_url = get_privatetunnel_pkg_url(app_name,app_url)
  rem_ver = File.basename(pkg_url,".dmg")
  rem_ver = rem_ver.split(/-/)[2]
  return rem_ver
end

def get_privatetunnel_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_privatetunnel_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_privatetunnel_post_install(app_name,app_url)
  return
end
