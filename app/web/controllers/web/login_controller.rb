# frozen_string_literal: true

module Web
  ##
  # Handles login
  class LoginController < WebController
    get('/login') { erb :login, layout: :layout_anonymous }

    post '/login' do
      session_aggregate = Commands.handle('Session', 'Start', post_params)
      session[:member_id] = session_aggregate.member_id
      flash[:success] = 'Login Successful'
      redirect '/contacts'
    end

    private

    def post_params
      params.slice('username', 'password')
    end
  end
end
