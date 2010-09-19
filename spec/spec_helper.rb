require 'rubygems'

require 'bundler'
Bundler.setup

require 'rake'

$:.unshift File.expand_path('../lib', __FILE__)
require 'bueller'

Dir.glob(File.expand_path('support/**/*.rb', File.dirname(__FILE__))).each { |f| require f }
