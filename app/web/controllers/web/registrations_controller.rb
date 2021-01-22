# frozen_string_literal: true

module Web
  ##
  # Handles Registrations
  class RegistrationsController < WebController
    get('/register') { erb :register, layout: :layout_anonymous }

    post '/register' do
      Commands.handle('Registration', 'NewRegistration', post_params)
      flash[:success] = 'Registration email sent. <small>Please check your spam
      folder too.</small>'
      redirect '/'
    rescue Aggregates::Registration::EmailAlreadySentError
      render_error(
        'Emailaddress is already registered. Do you want to login instead?'
      )
    end

    private

    def post_params
      post_params = params.slice(:password, :email)
      post_params[:handle] = Handle.new(params[:username]).to_s
      post_params
    end
  end
end
