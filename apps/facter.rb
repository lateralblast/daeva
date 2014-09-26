#
# Routines for Facter
#

def get_facter_app_name()
  app_name = "facter"
  return app_name
end

def get_facter_app_type()
  app_type = "app"
  return app_type
end

def get_facter_app_url()
  app_url = "http://downloads.puppetlabs.com/mac/"
  return app_url
end

def get_facter_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/facter/)[-1].split(/"/)[7]
  pkg_url = app_url+pkg_url
  return pkg_url
end

def get_facter_rem_ver(app_name,app_url)
  pkg_url = get_facter_pkg_url(app_name,app_url)
  rem_ver = File.basename(pkg_url,".dmg").split(/-/)[1]
  return rem_ver
end

def get_facter_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_facter_loc_ver(app_name)
  loc_ver = "Not installed"
  if File.exist?(app_name)
    loc_ver = %x[#{app_name} --version].chomp
  end
  return loc_ver
end

def do_facter_post_install(app_name,app_url)
  return
end
