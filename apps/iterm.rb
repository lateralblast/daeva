#
# Routines for iTerm2
#

def get_iterm_app_name()
  app_name = "iTerm"
  return app_name
end

def get_iterm_app_type()
  app_type = "app"
  return app_type
end

def get_iterm_app_url()
  app_url = "http://iterm2.com/downloads.html"
  return app_url
end

def get_iterm_pkg_url(app_name,app_url)
  app_url = get_iterm_app_url()
  arch    = %x[uname -m]
  if arch.match(/x86/)
    search = "Intel"
  else
    search = "PPC"
  end
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/#{search}/)[0].split(/"/)[1]
  return pkg_url
end

def get_iterm_rem_ver(app_name,app_url)
  pkg_url = get_iterm_pkg_url(app_name,app_url)
  rem_ver = File.basename(pkg_url,".zip")
  rem_ver = rem_ver.split(/-/)[-1].gsub(/_/,".")
  return rem_ver
end

def get_iterm_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_iterm_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split(/-/)[0]
  return loc_ver
end

def do_iterm_post_install(app_name,app_url)
  return
end
