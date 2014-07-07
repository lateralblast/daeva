#
# Routines for Evernote
#

def get_evernote_app_name()
  app_name = "Evernote"
  return app_name
end

def get_evernote_app_type()
  app_type = "app"
  return app_type
end

def get_evernote_app_url()
  app_url = "http://www.macupdate.com/app/mac/27456/evernote"
  return app_url
end

def get_evernote_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/zip/)[0].split(/"/)[3]
  pkg_url = "http://www.macupdate.com"+pkg_url
  return pkg_url
end

def get_evernote_rem_ver(app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/appversinfo/)[0].split(/<\/span>/)[1].split(/>/)[1]
  return rem_ver
end

def get_evernote_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_evernote_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_evernote_post_install(app_name)
  return
end
