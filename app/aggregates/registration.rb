# frozen_string_literal: true

module Aggregates
  ##
  # A +Registration+ represents a person who has registered but is not a
  # +Member+ yet.
  # It will become a +Member+ on finishing the registration.
  class Registration
    include EventSourcery::AggregateRoot

    apply RegistrationRequested do
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
  end
end
