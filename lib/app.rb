require 'sinatra/base'

class App < Sinatra::Base

  get '/' do
    'Welcome home!'
  end

end
