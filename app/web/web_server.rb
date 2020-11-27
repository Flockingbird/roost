# frozen_string_literal: true

require 'sinatra/contrib'
require_relative 'server'

Dir.glob("#{__dir__}/../commands/**/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/view_models/*.rb").sort.each { |f| require f }

##
# The webserver. Sinatra HTML only server. Serves HTML and digests FORM-encoded
# requests
class WebServer < Server
  use Rack::MethodOverride
  helpers Sinatra::ContentFor

  enable :sessions

  error UnprocessableEntity do |error|
    body render_error(error.message)
    status 422
  end

  error BadRequest do |error|
    ## TODO: find out how to re-render a form with errors instead
    body render_error(error.message)
    status 400
  end

  get('/') { erb :home }
  get('/login') { erb :login, layout: :layout_anonymous }
  get('/register') { erb :register, layout: :layout_anonymous }
  get('/contacts') { erb :contacts, layout: :layout_member }
  get('/register/success') { erb :register_success, layout: :layout_anonymous }

  post '/register' do
    handle_command('Registration', 'NewRegistration', registration_params)
    redirect '/register/success'
  rescue Aggregates::Registration::EmailAlreadySentError
    render_error(
      'Emailaddress is already registered. Do you want to login instead?'
    )
  end

  get '/confirmation/:aggregate_id' do
    handle_command('Registration', 'Confirm',
                   aggregate_id: params[:aggregate_id])
    erb :confirmation_success
  rescue Aggregates::Registration::AlreadyConfirmedError
    render_error(
      'Could not confirm. Maybe the link in the email expired, or was'\
      ' already used?'
    )
  end

  post '/login' do
    session_aggregate = handle_command('Session', 'Start', login_params)
    session[:member_id] = session_aggregate.member_id
    redirect '/contacts'
  end

  get '/profile' do
    erb :profile, layout: :layout_member, locals: { profile: current_member }
  end

  put '/profile' do
    handle_command('Profile', 'Update',
                   profile_params.merge(aggregate_id: member_id))
    redirect '/profile'
  end

  get '/profile/edit' do
    erb(
      :profile_edit,
      layout: :layout_member,
      locals: { profile: current_member }
    )
  end

  get '/updates' do
    updates = ViewModels::Update.from_collection(
      Projections::Updates::Query.for_member(member_id)
    )
    erb :updates, layout: :layout_member, locals: { updates: updates }
  end

  private

  def registration_params
    params.slice('username', 'password', 'email')
  end

  def login_params
    params.slice('username', 'password')
  end

  def profile_params
    params.slice('bio', 'name')
  end

  def render_error(message)
    content_for(:title, 'Error')
    erb(:error, locals: { message: message }, layout: :layout_anonymous)
  end

  def current_member
    OpenStruct.new(super)
  end

  def member_id
    session[:member_id]
  end
end
