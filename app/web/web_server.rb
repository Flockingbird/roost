# frozen_string_literal: true

require_relative 'server'

Dir.glob("#{__dir__}/../commands/**/*.rb").sort.each { |f| require f }

##
# The webserver. Sinatra HTML only server. Serves HTML and digests FORM-encoded
# requests
class WebServer < Server
  get '/' do
    erb :home
  end

  get '/register' do
    erb :register
  end

  post '/register' do
    command = Commands::Registration::NewRegistration::Command.new(
      registration_params
    )
    Commands::Registration::NewRegistration::CommandHandler.new(
      command: command
    ).handle

    redirect '/register/success'
  rescue Aggregates::Registration::EmailAlreadySentError
    render_error(
      'Emailaddress is already registered. Do you want to login instead?'
    )
  end

  get '/register/success' do
    erb :register_success
  end

  get '/confirmation/:aggregate_id' do
    command = Commands::Registration::Confirm::Command.new(
      aggregate_id: params[:aggregate_id]
    )
    Commands::Registration::Confirm::CommandHandler.new(
      command: command
    ).handle

    erb :confirmation_success
  rescue Aggregates::Registration::AlreadyConfirmedError
    render_error(
      'Could not confirm. Maybe the link in the email expired, or was'\
      ' already used?'
    )
  end

  private

  def registration_params
    params.slice('username', 'password', 'email')
          .merge(aggregate_id: aggregate_id)
  end

  def render_error(message)
    erb(:error, locals: { message: message })
  end
end
