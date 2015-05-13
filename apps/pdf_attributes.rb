#
# Routines for PDF Attributes
#

def get_pdf_attributes_app_name()
  app_name = "PDF Attributes"
  return app_name
end

def get_pdf_attributes_app_type()
  app_type = "store"
  return app_type
end

def get_pdf_attributes_app_url()
  app_url = "https://itunes.apple.com/us/app/pdf-attributes/id593341977?mt=12"
  return app_url
end

def get_pdf_attributes_pkg_url(app_name,app_url)
  app_url = get_pdf_attributes_app_url()
  pkg_url = get_macappstore_url(app_url)
  return pkg_url
end

def get_pdf_attributes_rem_ver(app_name,app_url)
  app_url = get_pdf_attributes_app_url()
  rem_ver = get_macappstore_ver(app_url)
  return rem_ver
end

def get_pdf_attributes_pkg_type()
  pkg_type = "zip"
  return pkg_type
end

def get_pdf_attributes_loc_ver(app_name)
  loc_ver = get_app_ver(app_name)
  return loc_ver
end

def do_pdf_attributes_post_install(app_name,app_url)
  return
end
