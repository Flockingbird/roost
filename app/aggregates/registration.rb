# frozen_string_literal: true

module Aggregates
  ##
  # A +Registration+ represents a person who has registered but is not a
  # +Member+ yet.
  # It will become a +Member+ on finishing the registration.
  class Registration
    include EventSourcery::AggregateRoot

    UUID_REGISTRATION_NAMESPACE = UUIDTools::UUID.parse(
      '2282b78c-85d6-419f-b240-0263d67ee6e6'
    )

    def self.aggregate_id_for_email(email)
      UUIDTools::UUID.sha1_create(UUID_REGISTRATION_NAMESPACE, email).to_s
    end

    # A Registration can only be confirmed once.
    AlreadyConfirmedError = Class.new(StandardError)
    # Only one email is allowed to be sent per Registration Aggregate
    EmailAlreadySentError = Class.new(StandardError)

    apply ConfirmationEmailSent do
      @confirmation_email_sent = true
    end

    apply RegistrationRequested do
    end

    apply RegistrationConfirmed do
      # TODO: build a generic lock mechanism with protection into an
      # ApplicationAggregate that protects against mutation
      @locked = true
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
    end

    # Confirm a new registration. This causes the registration to be finalized.
    def confirm(payload)
      raise AlreadyConfirmedError if @confirmed

      apply_event(
        RegistrationConfirmed,
        aggregate_id: id,
        body: payload
      )
    end
  end
end
