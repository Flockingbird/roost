# frozen_string_literal: true

module Web
  ##
  # Handles incoming redirects from remotes to confirm an action
  class RemoteConfirmationsController < WebController
    # TODO: authenticate and authorize
    get '/remote_confirmation' do
      erb(
        :remote_confirmation,
        layout: :layout_member,
        locals: {
          message: message,
          form_action: form_action,
          target: target,
          taget_type: target_type
        }
      )
    end

    private

    # TODO: Once we have more actions, fetch this from signed attributes and
    # pull through an allowlist
    def form_action
      'contacts'
    end

    # TODO: Unhardcode this message
    def message
      "As @harry@example.com you want to follow #{target}"
    end

    # TODO: Fetch the target from attributes
    def target
      '@luna@ravenclaw.example.org'
    end

    # TODO: Once we have more target types, fetch this from signed attributes
    # and pull through an allowlist
    def target_type
      'account'
    end
  end
end
