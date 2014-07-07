#
# Routines for Alarm Clock
#

def get_alarm_clock_app_name()
  app_name = "Alarm Clock"
  return app_name
end

def get_alarm_clock_app_type()
  app_type = "app"
  return app_type
end

def get_alarm_clock_app_url()
  app_url = "http://www.macupdate.com/app/mac/20597/alarm-clock"
  return app_url
end

def get_alarm_clock_pkg_url(app_url)
  pkg_url = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/zip/)[0].split(/"/)[3]
  pkg_url = "http://www.macupdate.com"+pkg_url
  return pkg_url
end

def get_alarm_clock_rem_ver(app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/appversinfo/)[0].split(/<\/span>/)[1].split(/>/)[1]
  return rem_ver
end

def get_alarm_clock_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_alarm_clock_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_alarm_clock_post_install(app_name)
  return
end
