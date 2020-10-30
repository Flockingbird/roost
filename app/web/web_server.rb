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
    Commands::Registration::NewRegistration::CommandHandler.new.handle(command)
    redirect '/register/success'
  end

  get '/register/success' do
    erb :register_success
  end

  private

  def registration_params
    params.slice('username', 'password', 'email')
          .merge(aggregate_id: aggregate_id)
  end
end
