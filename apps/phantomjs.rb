#
# Routines for PhantomJS
#

def get_phantomjs_app_name()
  app_name = "PhantomJS"
  return app_name
end

def get_phantomjs_app_type()
  app_type = "bin"
  return app_type
end

def get_phantomjs_app_url()
  app_url = "http://phantomjs.org/download.html"
  return app_url
end

def get_phantomjs_pkg_url(app_name,app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/macosx/)[0].split(/"/)[1]
  return pkg_url
end

def get_phantomjs_rem_ver(app_name,app_url)
  pkg_url = get_phantomjs_pkg_url(app_name,app_url)
  rem_ver = File.basename(pkg_url)
  rem_ver = rem_ver.split(/-/)[1]
  return rem_ver
end

def get_phantomjs_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_phantomjs_loc_ver(app_name)
  bin_file = "/usr/local/bin/phantomjs"
  if !File.exist?(bin_file)
    loc_ver = "Not Installed"
  else
    loc_ver = %x[#{bin_file} --version].chomp
  end
  return loc_ver
end

def do_phantomjs_post_install(app_name,app_url)
  return
end
