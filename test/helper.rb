ENV['RACK_ENV'] = 'test'

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib)

require 'app'
require 'minitest/autorun'
