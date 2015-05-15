# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'bundler'
Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'WIMBY'
  # So it does not display on the splash screen
  app.info_plist['UIStatusBarHidden'] = true
  app.frameworks += %w(CoreData MapKit)

  app.provisioning_profile = '/Users/lori/Library/MobileDevice/Provisioning Profiles/8ED44B10-E083-4FBA-9D82-719A561B4174.mobileprovision'
  app.codesign_certificate = 'iPhone Developer: Lori Olson (856MK7QV4X)'

  # Dependencies
  app.pods do
    pod 'NVSlideMenuController'
    pod 'AFNetworking'
    pod 'CCHMapClusterController'
  end
  app.vendor_project('vendor/Tapstream', :static)

  app.files = (
    app.files.select{|f| f =~ %r(/vendor/bundle/) } +
    app.files.select{|f| f =~ %r(/lib/) } +
    app.files
  ).uniq
end
