#
# Routines for GitHub
#

def get_github_app_name()
  app_name = "GitHub"
  return app_name
end

def get_github_app_type()
  app_type = "app"
  return app_type
end

def get_github_app_url()
  app_url = "http://www.macupdate.com/app/mac/39062/github"
  return app_url
end

def get_github_pkg_url(app_url)
  pkg_url = "https://central.github.com/mac/latest"
  return pkg_url
end

def get_github_rem_ver(app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/appversinfo/)[0].split(/<\/span>/)[1].split(/>/)[1]
  return rem_ver
end

def get_github_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_github_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  loc_ver = loc_ver.split(/,/)[0]
  return loc_ver
end

def do_github_post_install(app_name)
  return
end
