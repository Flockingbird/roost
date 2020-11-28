# frozen_string_literal: true

require_relative 'mixins/attributes'

module Aggregates
  ##
  # A +Member+ is a registered, available account on an +Instance+.
  # This can be a human, bot, or other actor. It can login, has a profile
  # and can interact with other members on this and other +Instances+
  class Member
    include EventSourcery::AggregateRoot
    include Attributes

    apply MemberAdded do |event|
    end

    apply MemberInvited do |event|
    end

    apply MemberBioUpdated do |event|
      write_attributes(event.body.slice('bio'))
    end

    def add_member(payload)
      apply_event(MemberAdded, aggregate_id: id, body: payload)
      self
    end

    def invite_member(payload)
      apply_event(MemberInvited, aggregate_id: id, body: payload)
      self
    end

    def update_bio(payload)
      new_bio = payload.slice('bio')
      return self if bio == new_bio['bio'].to_s

      apply_event(MemberBioUpdated, aggregate_id: id, body: new_bio)
      self
    end

    def bio
      attributes[:bio]
    end
  end
end
