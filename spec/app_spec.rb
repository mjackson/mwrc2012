require File.expand_path('../helper', __FILE__)
require 'sinatra/spec'
require 'app'

describe App do
  describe 'GET /' do
    it 'should respond ok' do
      get '/'
      last_response.status.must_equal 200
    end
  end
end
