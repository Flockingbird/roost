# frozen_string_literal: true

module Aggregates
  ##
  # A +Contact+ is a profile, member, remote member, or unregistered
  # that a member has in her contacts list.
  class Contact
    include EventSourcery::AggregateRoot

    def initialize(*arguments)
      @added = false
      super(*arguments)
    end

    apply ContactAdded do
      @added = true
    end

    def add(payload)
      raise UnprocessableEntity, 'Contact is already added' if @added

      apply_event(ContactAdded, aggregate_id: id, body: payload)
      self
    end
  end
end
