#
# Routines for Brackets
#

def get_brackets_app_name()
  app_name = "Brackets"
  return app_name
end

def get_brackets_app_type()
  app_type = "app"
  return app_type
end

def get_brackets_app_url()
  app_url = "http://brackets.io/"
  return app_url
end

def get_brackets_pkg_url(app_name,app_url)
  pkg_url = "https://github.com/adobe/brackets/releases/latest"
  pkg_url = Net::HTTP.get(URI.parse(pkg_url)).split("\n").grep(/redirected/)[0].split(/"/)[1]
  pkg_url = Net::HTTP.get(URI.parse(pkg_url)).split("\n").grep(/dmg/)[0].split(/"/)[1]
  pkg_url = "https://github.com/"+pkg_url
  return pkg_url
end

def get_brackets_rem_ver(app_name,app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/download-brackets-version/)[0].split(/>/)[3].split(/</)[0]
  return rem_ver
end

def get_brackets_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_brackets_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_brackets_post_install(app_name,app_url)
  return
end
