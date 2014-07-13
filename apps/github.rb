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

def get_github_pkg_url(app_name,app_url)
  pkg_url = "https://central.github.com/mac/latest"
  return pkg_url
end

def get_github_rem_ver(app_name,app_url)
  rem_ver = get_macupdate_ver(app_name,app_url)
  rem_ver = rem_ver.split(/ /)[0]
  return rem_ver
end

def get_github_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_github_loc_ver(app_name)
  loc_ver = get_min_ver(app_name)
  return loc_ver
end

def do_github_post_install(app_name)
  return
end
