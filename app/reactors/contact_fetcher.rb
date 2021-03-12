# frozen_string_literal: true

module Reactors
  ##
  # Adds an actor to a members' followers on various Events
  class ContactFetcher
    include EventSourcery::Postgres::Reactor

    processor_name :contact_fetcher

    emits_events PeerSynched

    process PeerFetchRequested do |event|
      emit_event(
        PeerSynched.new(
          aggregate_id: event.aggregate_id,
          body: event.body,
          causation_id: event.uuid
        )
      )
    end
  end
end
