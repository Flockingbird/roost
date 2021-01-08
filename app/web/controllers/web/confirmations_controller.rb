# frozen_string_literal: true

module Web
  ##
  # Handles the registration confirmation links
  class ConfirmationsController < WebController
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
  end
end
