$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'byebug'
require 'simplecov'
require 'codeclimate-test-reporter'
require 'etventure_collage_maker'

# Simple Cov configuration
SimpleCov.start

# Code Climate reporter configuration
CodeClimate::TestReporter.start
