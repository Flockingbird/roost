# frozen_string_literal: true

module Reactors
  ##
  # Sends the confirmation mail to a new registrant
  class ConfirmationMailer
    include EventSourcery::Postgres::Reactor

    processor_name :confirmation_mailer

    emits_events ConfirmationEmailSent

    process RegistrationRequested do |event|
      address = event.body['email']
      aggregate_id = event.aggregate_id

      # TODO: implement a failure handling catching errors from Pony.
      email_attrs = {
        to: address,
        from: 'Bèr at Flockingbird <ber@flockinbird.social>',
        subject: 'Welcome to Flockingbird. Please confirm your email address',
        body: MailRenderer.new.render(
          :registration_mail,
          confirmation_url: confirmation_url(aggregate_id)
        )
      }
      Mail.new(email_attrs).deliver

      emit_event(
        ConfirmationEmailSent.new(
          aggregate_id: aggregate_id,
          body: { email_attrs: email_attrs }
        )
      )
    end

    private

    def confirmation_url(aggregate_id)
      "#{Roost.config.web_url}/confirmation/#{aggregate_id}"
    end
  end
end
