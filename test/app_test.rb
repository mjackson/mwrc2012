require File.expand_path('../helper', __FILE__)
require 'rack/test'

class AppTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    App.new
  end

  def test_home
    get '/'
    assert last_response.ok?
  end
end
