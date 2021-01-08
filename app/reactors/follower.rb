# frozen_string_literal: true

module Reactors
  ##
  # Adds an actor to a members' followers on various Events
  class Follower
    include EventSourcery::Postgres::Reactor

    processor_name :follower

    emits_events FollowerAdded

    process MemberTagAdded do |event|
      emit_event(
        FollowerAdded.new(
          aggregate_id: event.aggregate_id,
          body: { follower_id: event.body['author_id'] },
          causation_id: event.uuid
        )
      )
    end
  end
end
