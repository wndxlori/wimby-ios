# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
$:.unshift("~/.rubymotion/rubymotion-templates")
require 'motion/project/template/ios'

require 'bundler'
Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  define_icon_defaults!(app)

  app.name = 'WIMBY'
  app.identifier = 'com.wndx.wimby'
  app.deployment_target = '13.7'
  app.archs['iPhoneOS'] = ['arm64']
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
    app.version = '1.1.3'

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

  app.info_plist['UIRequiredDeviceCapabilities'] = ['arm64']

  app.frameworks += %w(AdSupport CoreData MapKit WebKit)
  app.files

  app.detect_dependencies = true

  # Dependencies
  app.pods do
    pod 'NVSlideMenuController'
    pod 'AFNetworking'
    pod 'CCHMapClusterController'
    pod 'UIDevice-Hardware'
  end

end

task :promax do
  exec 'rake device_name="iPhone 13 Pro Max"'
end
task :mini do
  exec 'rake device_name="iPhone 12 mini"'
end
task :pro do
  exec 'rake device_name="iPhone 11 Pro"'
end
task :se do
  exec 'rake device_name="iPhone SE (2nd generation)"'
end

task 'build:icons' => 'resources/app-icon.icon_asset'

def define_icon_defaults!(app)
  # This is required as of iOS 11.0 (you must use asset catalogs to
  # define icons or your app will be rejected. More information in
  # located in the readme.

  app.info_plist['CFBundleIcons'] = {
     'CFBundlePrimaryIcon' => {
       'CFBundleIconName' => 'AppIcon',
       'CFBundleIconFiles' => ['AppIcon60x60']
     }
   }

   app.info_plist['CFBundleIcons~ipad'] = {
     'CFBundlePrimaryIcon' => {
       'CFBundleIconName' => 'AppIcon',
       'CFBundleIconFiles' => ['AppIcon60x60', 'AppIcon76x76']
     }
   }
 end
