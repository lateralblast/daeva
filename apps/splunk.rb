#
# Routines for Splunk
#

def get_splunk_app_name()
  app_name = "Splunk"
  return app_name
end

def get_splunk_app_type()
  app_type = "app"
  return app_type
end

def get_splunk_app_url()
  app_url = "http://www.splunk.com/download?r=header&ac=macupdate-dl"
  return app_url
end

def get_splunk_pkg_url(app_name,app_url)
  rem_ver  = get_splunk_rem_ver(app_url)
  base_url = "http://www.splunk.com/page/download_track?file="
  pkg_url  = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[3].split(/\=/)[1].split(/\&/)[0]
  post_url = "&ac=macupdate-dl&wget=true&name=wget&platform=MacOS&architecture=x86_64&version="+rem_ver+"&product=splunk&typed=release"
  pkg_url  = base_url+pkg_url+post_url
  return pkg_url
end

def get_splunk_rem_ver(app_name,app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/dmg/)[0].split(/"/)[3].split(/\=/)[1].split(/\&/)[0].split(/\-/)[1]
  return rem_ver
end

def get_splunk_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_splunk_loc_ver(app_name)
  loc_ver = %x[/Applications/Splunk/bin/splunk --version].chomp.split(/ /)[1]
  return loc_ver
end

def do_splunk_post_install(app_name)
  system("sudo sh -c '/Applications/Splunk/bin/splunk start --accept-license --answer-yes'")
  return
end
