# frozen_string_literal: true

require_relative 'server'
require 'rack/jwt'

Dir.glob("#{__dir__}/../commands/**/*.rb").sort.each { |f| require f }

##
# The API server. Sinatra API only server. Main trigger for the commands
# and entrypoint for reading data.
class ApiServer < Server
  # Find authentication details
  get '/session' do
    body current_member.to_h.slice(:member_id, :username, :name, :email).to_json
    status(200)
  end

  # Create a new invitation
  post '/invitations/:aggregate_id' do
    invitation_params = json_params.merge(inviter: current_member)

    command = Commands::Member::InviteMember::Command.new(invitation_params)
    Commands::Member::InviteMember::CommandHandler.new(command: command).handle
    status(201)
    headers('Location' => invitation_url(command.aggregate_id))
    body '{}'
  end

  configure do
    # TODO: find a proper place to configure this
    jwt_args = {
      secret: ENV['JWT_SECRET'],
      verify: true,
      options: {}
    }
    use Rack::JWT::Auth, jwt_args
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

  def invitation_url(id)
    URI.join(request.base_url, "/invitations/#{id}").to_s
  end

  def member_id
    request.env['jwt.payload']['sub']
  end
end
