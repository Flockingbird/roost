# frozen_string_literal: true

module Reactors
  ##
  # Generates a MemberAdded Event.
  class MemberGenerator
    include EventSourcery::Postgres::Reactor

    processor_name :member_generator
    emits_events MemberAdded

    process RegistrationConfirmed do |event|
      emit_event(
        MemberAdded.new(
          aggregate_id: SecureRandom.uuid,
          body: event.body,
          causation_id: event.id
        )
      )
    end
  end
end
