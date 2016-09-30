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
  app.deployment_target = '9.3'
  app.development do
    app.codesign_certificate = MotionProvisioning.certificate(
      type: :development,
      platform: :ios)

    app.provisioning_profile = MotionProvisioning.profile(
      bundle_identifier: app.identifier,
      app_name: app.name,
      platform: :ios,
      type: :development)
  end

  app.release do
    app.version = '0.2.0'

    app.entitlements['beta-reports-active'] = true

    app.codesign_certificate = MotionProvisioning.certificate(
      type: :distribution,
      platform: :ios)

    app.provisioning_profile = MotionProvisioning.profile(
      bundle_identifier: app.identifier,
      app_name: app.name,
      platform: :ios,
      type: :distribution)
  end

  # So it does not display on the splash screen
  app.info_plist['UIStatusBarHidden'] = true

  app.info_plist['NSLocationWhenInUseUsageDescription'] = 'WIMBY would like to show your location on the map'

  app.icons = %w(Icon-20 Icon-24 Icon-27.5 Icon-29 Icon-40 Icon-50 Icon-57 Icon-60 Icon-72 Icon-76 Icon-83.5 Icon-86 Icon-98)

  app.frameworks += %w(AdSupport CoreData MapKit WebKit)

  app.detect_dependencies = false

  # Dependencies
  app.pods do
    pod 'NVSlideMenuController'
    pod 'AFNetworking'
    pod 'CCHMapClusterController'
    pod 'Tapstream'
  end

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
task :iphone6s do
    exec 'rake device_name="iPhone 6s"'
end

desc "Run simulator on iPhone"
task :iphone6plus do
    exec 'rake device_name="iPhone 6 Plus"'
end

desc "Run simulator on iPhone"
task :iphone6splus do
    exec 'rake device_name="iPhone 6s Plus"'
end

desc "Run simulator in iPad Retina"
task :retina do
    exec 'rake device_name="iPad Retina"'
end

desc "Run simulator on iPad Air"
task :ipad do
    exec 'rake device_name="iPad Air"'
end