#
# Routines for iMeme
#

def get_imeme_app_name()
  app_name = "iMeme"
  return app_name
end

def get_imeme_app_type()
  app_type = "app"
  return app_type
end

def get_imeme_app_url()
  app_url = "http://www.michaelfogleman.com/imeme/"
  return app_url
end

def get_imeme_pkg_url(app_url)
  pkg_url = "http://www.michaelfogleman.com/static/iMeme.app.zip"
  return pkg_url
end

def get_imeme_rem_ver(app_url)
  rem_ver = "1.0"
  return rem_ver
end

def get_imeme_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_imeme_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_imeme_post_install(app_name)
  return
end
