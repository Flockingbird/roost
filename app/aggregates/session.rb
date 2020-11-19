# frozen_string_literal: true

module Aggregates
  ##
  # A +Session+ represents a person who is logged in.
  class Session
    include EventSourcery::AggregateRoot

    attr_reader :member_id

    apply SessionStarted do |event|
      @member_id = event.body['member_id']
    end

    def start(payload)
      apply_event(
        SessionStarted,
        aggregate_id: id,
        body: payload
      )
      self
    end
  end
end
