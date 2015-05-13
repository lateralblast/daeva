#
# Routines for wireshark
#

def get_wireshark_app_name()
  app_name = "Wireshark"
  return app_name
end

def get_wireshark_app_type()
  app_type = "pkg"
  return app_type
end

def get_wireshark_app_url()
  app_url = "https://www.wireshark.org/download.html"
  return app_url
end

def get_wireshark_pkg_url(app_name,app_url)
  rem_ver = get_wireshark_rem_ver(app_name,app_url)
  pkg_url = "https://www.wireshark.org/download/osx/Wireshark%20"+rem_ver+"%20Intel%2064.dmg"
  return pkg_url
end

def get_wireshark_rem_ver(app_name,app_url)
  app_url = get_wireshark_app_url()
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/Development Release/)[0].split(/\(/)[1].split(/\)/)[0] 
  return rem_ver
end

def get_wireshark_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_wireshark_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_wireshark_post_install(app_name,app_url)
  return
end
