# frozen_string_literal: true

require 'sinatra'
require 'rack/jwt'

Dir.glob("#{__dir__}/../commands/**/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/../projections/**/query.rb").sort.each { |f| require f }

##
# The webserver. Sinatra API only server. Main trigger for the commands
# and entrypoint for reading data.
# TODO: probably split into API-web and HTML-web.
class Server < Sinatra::Base
  get '/' do
    erb :home, format: :html
  end

  # Find authentication details
  get '/session' do
    content_type :json
    body current_member.to_h.to_json
    status(200)
  end

  # Create a new invitation
  post '/invitations/:aggregate_id' do
    content_type :json
    invitation_params = json_params.merge(inviter: current_member)

    command = Commands::Member::InviteMember::Command.new(invitation_params)
    Commands::Member::InviteMember::CommandHandler.new.handle(command)
    status(201)
    headers('Location' => invitation_url(command.aggregate_id))
    body '{}'
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
      },
      exclude: ['/']
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

  def current_member
    @current_member ||= Projections::Members::Query.find(
      request.env['jwt.payload']['sub']
    )
  end

  def json_params
    # Coerce this into a symbolised Hash so Sinatra data
    # structures don't leak into the command layer
    request_body = request.body.read
    params.merge!(JSON.parse(request_body)) unless request_body.empty?

    params.transform_keys(&:to_sym)
  end

  def invitation_url(id)
    URI.join(request.base_url, "/invitations/#{id}").to_s
  end
end
