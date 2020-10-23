# frozen_string_literal: true

require 'sinatra'
require 'rack/jwt'

Dir.glob("#{__dir__}/../commands/**/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/../projections/**/query.rb").sort.each { |f| require f }

module Roost
  ##
  # The webserver. Sinatra API only server. Main trigger for the commands
  # and entrypoint for reading data.
  class Server < Sinatra::Base
    # Find authentication details
    get '/session' do
      body current_member.to_h.to_json
      status(200)
    end

    BadRequest = Class.new(StandardError)
    UnprocessableEntity = Class.new(StandardError)

    # Ensure our error handlers are triggered in development
    set :show_exceptions, :after_handler

    configure do
      # TODO: find a proper place to configure this
      jwt_args = {
        secret: ENV['JWT_SECRET'],
        verify: true,
        options: {
        }
      }
      use Rack::JWT::Auth, jwt_args
    end

    configure :development, :test do
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

    def current_member
      @current_member ||= Roost::Projections::Members::Query.find(request.env['jwt.payload']['sub'])
    end

    def json_params
      # Coerce this into a symbolised Hash so Sinatra data
      # structures don't leak into the command layer
      request_body = request.body.read
      params.merge!(JSON.parse(request_body)) unless request_body.empty?

      params.transform_keys(&:to_sym)
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
