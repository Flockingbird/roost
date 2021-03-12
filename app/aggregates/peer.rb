# frozen_string_literal: true

module Aggregates
  ##
  # A +Peer+ is a remote actor.
  class Peer
    include EventSourcery::AggregateRoot

    AWAIT_SYNCING_VALUE = 'Synching...'

    attr_reader :name, :bio

    def initialize(id, events)
      @name = AWAIT_SYNCING_VALUE
      @bio = AWAIT_SYNCING_VALUE
      super(id, events)
    end

    apply PeerSynched do
    end
  end
end
