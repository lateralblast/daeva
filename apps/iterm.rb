#
# Routines for iTerm2
#

def get_iterm_app_name()
  app_name = "iTerm"
  return app_name
end

def get_iterm_app_url()
  app_url = "http://www.iterm.com/#/section/downloads"
  return app_url
end

def get_iterm_pkg_url(app_url)
  if !File.exist?("/usr/local/bin/lftp")
    puts "Processing iTerm page requires lftp"
    if File.exist?("/usr/local/bin/brew")
      puts "Installing lftp with brew"
      %x[brew install lftp]
    else
      exit
    end
  end
  pkg_url = `lftp http://www.iterm2.com/#/section/downloads -e "ls ; exit" 2>&1`
  pkg_url = pkg_url.split(/\n/).grep(/beta/)[0].split(/ /)[-1]
  pkg_url = app_url+"/"+pkg_url
  return pkg_url
end

def get_iterm_rem_ver(app_url)
  pkg_url = get_iterm_pkg_url(app_url)
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

def do_iterm_post_install(app_name)
  return
end
