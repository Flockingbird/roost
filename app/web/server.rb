# frozen_string_literal: true

require 'sinatra'

Dir.glob("#{__dir__}/../commands/**/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/../projections/**/query.rb").sort.each { |f| require f }

module Roost
  ##
  # The webserver. Sinatra API only server. Main trigger for the commands
  # and entrypoint for reading data.
  class Server < Sinatra::Base
    post '/Members/:aggregate_id/AddMember' do
      command = Commands::Member::AddMember::Command.new(json_params)
      Commands::Member::AddMember::CommandHandler.new.handle(command)
      status 201
    end

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
