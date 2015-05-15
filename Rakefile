# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'bundler'
Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'WIMBY'
  app.identifier = 'com.wndx.wimby'
  # So it does not display on the splash screen
  app.info_plist['UIStatusBarHidden'] = true
  app.frameworks += %w(CoreData MapKit)

  app.provisioning_profile = '/Users/lori/Library/MobileDevice/Provisioning Profiles/c3ef702e-a61b-45fc-aa93-acf08f6a1a25.mobileprovision'
  app.codesign_certificate = 'iPhone Developer: Lori Olson (856MK7QV4X)'

  app.detect_dependencies = false

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
