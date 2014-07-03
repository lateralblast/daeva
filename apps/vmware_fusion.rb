#
# Routines for VMware Fusion
#

def get_vmware_fusion_app_name()
  app_name = "VMware Fusion"
  return app_name
end

def get_vmware_fusion_app_type()
  app_type = "app"
  return app_type
end

def get_vmware_fusion_app_url()
  app_url = "http://www.macupdate.com/app/mac/23593/vmware-fusion"
  return app_url
end

def get_vmware_fusion_pkg_url(app_url)
  pkg_url = "http://www.vmware.com/go/tryfusion"
  return pkg_url
end

def get_vmware_fusion_rem_ver(app_url)
  rem_ver = Net::HTTP.get(URI.parse(app_url)).split("\n").grep(/appversinfo/)[0].split(/<\/span>/)[1].split(/>/)[1]
  return rem_ver
end

def get_vmware_fusion_pkg_type()
  pkg_type = "dmg"
  return pkg_type
end

def get_vmware_fusion_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_vmware_fusion_post_install(app_name)
  return
end
