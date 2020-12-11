# frozen_string_literal: true

require 'sinatra/contrib'
require 'sinatra/flash'

module Web
  ##
  # Fallback controller for website. Serves HTML and digests FORM-encoded
  # requests
  class WebController < ::ApplicationController
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

    error NotFound do |error|
      body render_error(error.message)
      status 404
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

    protected

    def notifications
      flash(:flash).collect do |message|
        erb(:notification, locals: { message: message })
      end.join
    end

    def render_error(message)
      content_for(:title, 'Error')
      erb(:error, locals: { message: message }, layout: :layout_anonymous)
    end

    def member_id
      session[:member_id]
    end
  end
end
