# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

require 'bundler'
Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'WIMBY'
  app.frameworks += %w(CoreData)
  Dir.glob(File.join(File.dirname(__FILE__), '../faster_csv/lib/*.rb')).each do |file|
    app.files.unshift(file)
  end
end
