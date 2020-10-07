require 'sinatra'

Dir.glob(__dir__ + '/../commands/**/*.rb').each { |f| require f }
Dir.glob(__dir__ + '/../projections/**/query.rb').each { |f| require f }

module Roost
  class Server < Sinatra::Base
    BadRequest = Class.new(StandardError)
    UnprocessableEntity = Class.new(StandardError)

    # Ensure our error handlers are triggered in development
    set :show_exceptions, :after_handler

    configure :development do
      require 'better_errors'
      use BetterErrors::Middleware
      BetterErrors.application_root = __dir__
    end

    error UnprocessableEntity do |error|
      body "Unprocessable Entity: #{error.message}"
      status 422
    end

    error BadRequest do |error|
      body "Bad Request: #{error.message}"
      status 400
    end

    before do
      content_type :json
    end

    def json_params
      # Coerce this into a symbolised Hash so Sinatra data
      # structures don't leak into the command layer

      request_body = request.body.read
      unless request_body.empty?
        params.merge!(JSON.parse(request_body))
      end

      Hash[
        params.map{ |k, v| [k.to_sym, v] }
      ]
    end

    # Add your API routes here!
    #
    # eg.
    # get '/todos' do
    #   ...
    # end
    #
    # post '/todo/:id' do
    #   ...
    # end
  end
end
