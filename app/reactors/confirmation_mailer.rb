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
        body: render(:registration_mail, event.body)
      )
      email.deliver
    end

    private

    def render(template, event_body)
      file = File.read(File.join("app/mail/#{template}.erb"))
      ERB.new(file).result_with_hash(
        confirmation_url: confirmation_url(event_body['email'])
      )
    end

    def confirmation_url(email)
      token = Digest::SHA1.hexdigest("#{email},#{Roost.config.secret_base}")
      "#{Roost.config.web_url}/confirmation/#{token}"
    end
  end
end
