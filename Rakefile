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

  app.provisioning_profile = '/Users/lori/Library/MobileDevice/Provisioning Profiles/b2209784-4dad-4f8d-8c66-691f3990c8b4.mobileprovision'
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

desc "Run simulator on iPhone"
task :iphone4 do
    exec 'rake device_name="iPhone 4s"'
end

desc "Run simulator on iPhone"
task :iphone5 do
    exec 'rake device_name="iPhone 5"'
end

desc "Run simulator on iPhone"
task :iphone6 do
    exec 'rake device_name="iPhone 6"'
end

desc "Run simulator on iPhone"
task :iphone6plus do
    exec 'rake device_name="iPhone 6 Plus"'
end

desc "Run simulator in iPad Retina"
task :retina do
    exec 'rake device_name="iPad Retina"'
end

desc "Run simulator on iPad Air"
task :ipad do
    exec 'rake device_name="iPad Air"'
end