#
# Routines for Hiera
#

def get_hiera_app_name()
  app_name = "hiera"
  return app_name
end

def get_hiera_app_type()
  app_type = "app"
  return app_type
end

def get_hiera_app_url()
  app_url = "http://downloads.puppetlabs.com/mac/"
  return app_url
end

def get_hiera_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/hiera-[0-9]/)[-1].split(/"/)[7]
  pkg_url = app_url+pkg_url
  return pkg_url
end

def get_hiera_rem_ver(app_name,app_url)
  rem_ver = get_hiera_pkg_url(app_name,app_url)
  rem_ver = File.basename(rem_ver,".dmg").split(/-/)[1]
  return rem_ver
end

def get_hiera_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_hiera_loc_ver(app_name)
  loc_ver = %x[#{app_name} --version].chomp
  return loc_ver
end

def do_hiera_post_install(app_name,app_url)
  return
end
