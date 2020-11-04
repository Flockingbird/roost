# frozen_string_literal: true

module Aggregates
  ##
  # A +Registration+ represents a person who has registered but is not a
  # +Member+ yet.
  # It will become a +Member+ on finishing the registration.
  class Registration
    include EventSourcery::AggregateRoot

    AlreadyConfirmedError = Class.new(StandardError)

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
