# frozen_string_literal: true

module Aggregates
  ##
  # A +Member+ is a registered, available account on an +Instance+.
  # This can be a human, bot, or other actor. It can login, has a profile
  # and can interact with other members on this and other +Instances+
  class Member
    include EventSourcery::AggregateRoot

    apply MemberAdded do |event|
    end

    apply MemberInvited do |event|
    end

    apply MemberBioUpdated do |event|
      @bio = event.body['bio']
    end

    def add_member(payload)
      # Perform any relevant contextual validations on aggregate

      # Apply the event without persistence
      apply_event(
        MemberAdded,
        aggregate_id: id,
        body: payload
      )
      self
    end

    def invite_member(payload)
      # Perform any relevant contextual validations on aggregate

      # Apply the event without persistence
      apply_event(
        MemberInvited,
        aggregate_id: id,
        body: payload
      )
      self
    end

    def update_bio(payload)
      apply_event(
        MemberBioUpdated,
        aggregate_id: id,
        body: payload.slice('bio')
      )
      self
    end
  end
end
