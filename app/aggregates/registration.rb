# frozen_string_literal: true

module Aggregates
  ##
  # A +Registration+ represents a person who has registered but is not a
  # +Member+ yet.
  # It will become a +Member+ on finishing the registration.
  class Registration
    include EventSourcery::AggregateRoot

    # A Registration can only be confirmed once.
    AlreadyConfirmedError = Class.new(StandardError)
    # Only one email is allowed to be sent per Registration Aggregate
    EmailAlreadySentError = Class.new(StandardError)

    attr_reader :username, :password, :email

    def initialize(*arguments)
      super(*arguments)

      # set defaults
      @confirmation_email_sent ||= false
      @confirmed ||= false

      @username ||= ''
      @password ||= ''
      @email ||= ''
    end

    apply ConfirmationEmailSent do
      @confirmation_email_sent = true
    end

    apply RegistrationRequested do |event|
      @username,
      @password,
      @email = event.body.slice('username', 'password', 'email').values
    end

    apply RegistrationConfirmed do
      @confirmed = true
    end

    # Request a new registration. Depending on settings and current
    # state, this might lead to a new member eventually; if the request
    # is acknowledged.
    def request(payload)
      raise EmailAlreadySentError if @confirmation_email_sent

      apply_event(
        RegistrationRequested,
        aggregate_id: id,
        body: payload
      )
      self
    end

    # Confirm a new registration. This causes the registration to be finalized.
    def confirm(payload)
      raise AlreadyConfirmedError if @confirmed

      apply_event(
        RegistrationConfirmed,
        aggregate_id: id,
        body: payload
      )
      self
    end
  end
end
