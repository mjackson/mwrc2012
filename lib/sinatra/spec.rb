require 'sinatra/base'
require 'minitest/spec'
require 'rack/test'

# See https://gist.github.com/2040168
module Sinatra
  # This spec is a base for specs that describe Sinatra apps. It mixes in
  # Rack::Test::Methods and provides an #app method that resolves to the app,
  # so long as the app is used as the spec's +desc+, e.g.:
  #
  #   describe MyApp do
  #     describe "GET /" do
  #       it "should respond ok" do
  #         get "/"
  #         assert last_response.ok?
  #       end
  #     end
  #   end
  class Spec < MiniTest::Spec
    include Rack::Test::Methods

    # Returns +true+ if the given +desc+ is a class that is a descendant of
    # Sinatra::Base, for which Sinatra::Spec may be used.
    def self.is_base?(desc)
      Sinatra::Base > desc
    rescue TypeError
      false
    end

    # Returns an anonymous subclass of this spec's app class. The class is
    # subclassed so that each spec may modify its own copy of the app without
    # affecting others.
    def self.app_class
      @app_class ||= Class.new(is_base?(desc) ? desc : superclass.app_class)
    end

    # Returns the subclass of Sinatra::Base this spec describes.
    def app_class
      self.class.app_class
    end

    # Returns an instance of the #app_class fronted by its middleware. Used
    # by Rack::Test::Methods to call the app.
    def app
      app_class.new
    end
  end
end

# Register Sinatra::Spec to be used for all Sinatra::Base apps.
MiniTest::Spec.register_spec_type(Sinatra::Spec) do |desc|
  Sinatra::Spec.is_base?(desc)
end
