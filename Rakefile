# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'bundler'
Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'WIMBY'
  app.frameworks += %w(CoreData MapKit)

  app.provisioning_profile = '/Users/lori/Library/MobileDevice/Provisioning Profiles/631E679E-115A-48B9-A43C-B04146C80E31.mobileprovision'
  app.codesign_certificate = 'iPhone Developer: Lori Olson (856MK7QV4X)'

  # Dependencies
  app.pods do
    pod 'NVSlideMenuController'
    pod 'AFNetworking'
  end
end
