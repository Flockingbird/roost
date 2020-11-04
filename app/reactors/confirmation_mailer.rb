# frozen_string_literal: true

module Reactors
  ##
  # Sends the confirmation mail to a new registrant
  class ConfirmationMailer
    include EventSourcery::Postgres::Reactor

    processor_name :confirmation_mailer

    # emits_events ConfirmationEmailSent

    # table :reactor_registration_mailer do
    # column :todo_id, :uuid, primary_key: true
    # column :title,   :text
    # end

    process RegistrationRequested do |event|
      # TODO: implement a failure handling catching errors from Pony.
      email = Mail.new(
        to: event.body['email'],
        from: 'Bèr at Flockingbird <ber@flockinbird.social>',
        subject: 'Welcome to Flockingbird. Please confirm your email address',
        body: render(:registration_mail, confirmation_url(event.aggregate_id))
      )
      email.deliver
    end

    private

    def render(template, confirmation_url)
      file = File.read(File.join("app/mail/#{template}.erb"))
      ERB.new(file).result_with_hash(confirmation_url: confirmation_url)
    end

    def confirmation_url(aggregate_id)
      "#{Roost.config.web_url}/confirmation/#{aggregate_id}"
    end
  end
end
