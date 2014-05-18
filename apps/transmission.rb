#
# Routines for Transmission
#

def get_transmission_app_name()
  app_name = "Transmission"
  return app_name
end

def get_transmission_app_url()
  app_url = "https://build.transmissionbt.com/job/trunk-mac/lastBuild/"
  return app_url
end

def get_transmission_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/Transmission/)[0].split(/"/).grep(/Transmission/)[0]
  pkg_url = app_url+pkg_url
  return pkg_url
end

def get_transmission_rem_ver(app_url)
  pkg_url = get_transmission_pkg_url(app_url)
  rem_ver = File.basename(pkg_url,".dmg")
  rem_ver = rem_ver.split(/-/)[-1]
  return rem_ver
end

def get_transmission_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_transmission_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  if loc_ver !~ /()/
    loc_ver = loc_ver.gsub(/ \+ /,".").gsub(/[),(]/,"").split(/\./)[-1]
  else
    loc_ver = "No build number available"
  end
  return loc_ver
end

def do_transmission_post_install(app_name)
  return
end
