#
# Routines for VLC
#

def get_vlc_app_name()
  app_name = "VLC"
  return app_name
end

def get_vlc_app_url()
  app_url = "http://nightlies.videolan.org/build/macosx-intel/"
  return app_url
end

def get_vlc_pkg_url(app_url)
  pkg_url = app_url+"last"
  return pkg_url
end

def get_vlc_rem_date(app_url)
  rem_date = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/last/)[0].split(/\s+/)[6..7].join(" ")
  rem_date = DateTime.parse(rem_date).to_date
  return rem_date
end

def get_vlc_pkg_type()
  pkg_type = "zip"
  return pkg_type
end
