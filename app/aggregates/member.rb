# frozen_string_literal: true

module Roost
  module Aggregates
    ##
    # A +Member+ is a registered, available account on an +Instance+.
    # This can be a human, bot, or other actor. It can login, has a profile
    # and can interact with other members on this and other +Instances+
    class Member
      include EventSourcery::AggregateRoot

      apply MemberAdded do |event|
        # Mutate state of aggregate based on event, e.g.
        # @member_addmemberred_occurred = true
      end

      def add_member(payload)
        # Perform any relevant contextual validations on aggregate

        # Apply the event without persistence
        apply_event(
          MemberAdded,
          aggregate_id: id,
          body: payload
        )
      end
    end
  end
end
