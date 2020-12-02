# frozen_string_literal: true

require 'sinatra/contrib'
require 'sinatra/flash'
require_relative 'server'

Dir.glob("#{__dir__}/../commands/**/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/view_models/*.rb").sort.each { |f| require f }

##
# The webserver. Sinatra HTML only server. Serves HTML and digests FORM-encoded
# requests
class WebServer < Server
  use Rack::MethodOverride
  register Sinatra::Flash
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

  error Unauthorized do |_error|
    # TODO: render the login form below
    body render_error(
      'You are not logged in. Please <a href="/login">log in</a> or
       <a href="/register">register</a> to proceed'
    )
    # NOTE: we don't send the 401, as that requires a WWW-Authenticate header,
    # that we cannot send in session/cookie based auth.
    status 403
  end

  get('/') { erb :home }
  get('/login') { erb :login, layout: :layout_anonymous }
  get('/register') { erb :register, layout: :layout_anonymous }
  get('/contacts') { erb :contacts, layout: :layout_member }

  post '/register' do
    Commands.handle('Registration', 'NewRegistration', registration_params)
    flash[:success] = 'Registration email sent. <small>Please check your spam
    folder too.</small>'
    redirect '/'
  rescue Aggregates::Registration::EmailAlreadySentError
    render_error(
      'Emailaddress is already registered. Do you want to login instead?'
    )
  end

  get '/confirmation/:aggregate_id' do
    Commands.handle('Registration', 'Confirm',
                    aggregate_id: params[:aggregate_id])
    erb :confirmation_success
  rescue Aggregates::Registration::AlreadyConfirmedError
    render_error(
      'Could not confirm. Maybe the link in the email expired, or was'\
      ' already used?'
    )
  end

  post '/login' do
    session_aggregate = Commands.handle('Session', 'Start', login_params)
    session[:member_id] = session_aggregate.member_id
    flash[:success] = 'Login Successful'
    redirect '/contacts'
  end

  get '/profile' do
    requires_authorization
    profile = ViewModels::Profile.new(current_member)
    erb :profile, layout: :layout_member, locals: { profile: profile }
  end

  put '/profile' do
    requires_authorization
    Commands.handle('Profile', 'Update',
                    profile_params.merge(aggregate_id: member_id))
    redirect '/profile'
  end

  get '/profile/edit' do
    requires_authorization
    profile = ViewModels::Profile.new(current_member)
    erb(:profile_edit, layout: :layout_member, locals: { profile: profile })
  end

  get '/updates' do
    requires_authorization
    updates = ViewModels::Update.from_collection(
      Projections::Updates::Query.for_member(member_id)
    )
    erb :updates, layout: :layout_member, locals: { updates: updates }
  end

  private

  def notifications
    flash(:flash).collect do |message|
      %(<div class="notification is-#{message[0]}">
        <button class="delete"></button>
        #{message[1]}
      </div>)
    end.join
  end

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

  def member_id
    session[:member_id]
  end
end
