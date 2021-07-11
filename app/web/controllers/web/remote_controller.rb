# frozen_string_literal: true

module Web
  ##
  # Handles Remote redirects
  # TODO: sanitize and whitelist actions
  # TODO: handle misparsed handles
  # TODO: exchange server-server signed secrets with remote instance so that
  # remote instance knows this request is coming and can validate it.
  class RemoteController < WebController
    get '/remote' do
      erb(
        :remote,
        layout: :layout_anonymous,
        locals: {
          message: message,
          action: action,
          target: target,
          taget_type: target_type
        }
      )
    end

    post '/remote' do
      redirect remote_confirm_uri
    end

    private

    def remote_confirm_uri
      URI::HTTPS.build(
        host: Handle.parse(params[:handle]).domain,
        path: '/remote_confirmation',
        query: URI.encode_www_form(
          action: action,
          target: target,
          target_type: target_type
        )
      )
    end

    def action
      'follow'
    end

    def message
      'Provide your handle to follow @luna@ravenclaw.example.org'
    end

    def target
      '@luna.ravenclaw.example.org'
    end

    def target_type
      'account'
    end
  end
end
