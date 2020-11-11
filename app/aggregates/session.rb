# frozen_string_literal: true

module Aggregates
  ##
  # A +Session+ represents a person who is logged in.
  class Session
    include EventSourcery::AggregateRoot

    def start(_payload)
      self
    end
  end
end
