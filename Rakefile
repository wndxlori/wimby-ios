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
    app.codesign_certificate = "Apple Development: Lori Olson (856MK7QV4X)"
    app.provisioning_profile = "/Users/lori/Library/MobileDevice/Provisioning Profiles/9f5fbea4-be8c-4aae-9b52-ee7ae56b54c7.mobileprovision"
  end

  app.release do
    app.version = '1.2.3'

    app.codesign_certificate = "Apple Distribution: The WNDX Group Inc (S3E5U9BKJV)"
    app.provisioning_profile = "/Users/lori/Library/MobileDevice/Provisioning Profiles/d36555fb-59b9-4e25-a14f-eaef4ee5494f.mobileprovision"
  end

  # AppStore Stuff
  app.info_plist['ITSAppUsesNonExemptEncryption'] = false
  app.info_plist['LSApplicationCategoryType'] = 'public.app-category.reference'

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
  end

end

task :promax do
  exec 'rake device_name="iPhone 15 Pro Max"'
end
task :mini do
  exec 'rake device_name="iPhone 12 mini"'
end
task :pro do
  exec 'rake device_name="iPhone 15 Pro"'
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
