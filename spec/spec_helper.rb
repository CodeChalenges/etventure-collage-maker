require 'simplecov'
require 'codeclimate-test-reporter'

# Simple Cov configuration
SimpleCov.start do
  add_filter '/spec/'

  add_group 'Helpers',  'lib/helpers'
  add_group 'Services', 'lib/services'
end

# Code Climate reporter configuration
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'byebug'
require 'etventure_collage_maker'
