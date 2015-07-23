#
# Routines for packer
#

def get_packer_app_name()
  app_name = "packer"
  return app_name
end

def get_packer_app_type()
  app_type = "zip"
  return app_type
end

def get_packer_app_url()
  app_url = "https://packer.io/downloads.html"
  return app_url
end

def get_packer_pkg_url(app_name,app_url)
  pkg_arc = %[uname -p].chomp
  if pkg_arc.match(/386/)
    pkg_arc = "386"
  else
    pkg_arc = "amd64"
  end
  app_url = get_packer_app_url()
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/darwin_#{pkg_arc}/)[0].split(/"/)[1]
  return pkg_url
end

def get_packer_rem_ver(app_name,app_url)
  pkg_url = get_packer_pkg_url(app_name,app_url)
  rem_ver = pkg_url.split(/_/)[1]
  return rem_ver
end

def get_packer_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_packer_loc_ver(app_name)
  loc_bin = "/usr/local/bin/packer"
  if File.exist?(loc_bin)
    loc_ver = %x[#{loc_bin} --version].chomp
  else
    loc_ver = "0"
  end
  return loc_ver
end

def do_packer_post_install(app_name,app_url)
  return
end
