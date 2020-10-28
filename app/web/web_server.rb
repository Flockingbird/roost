# frozen_string_literal: true

require_relative 'server'

##
# The webserver. Sinatra HTML only server. Serves HTML and digests FORM-encoded
# requests
class WebServer < Server
  get '/' do
    erb :home, format: :html
  end
end
