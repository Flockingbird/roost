# frozen_string_literal: true

require_relative 'mixins/attributes'
require_relative 'member/tag'

require 'lib/aggregate_equality'

module Aggregates
  ##
  # A +Member+ is a registered, available account on an +Instance+.
  # This can be a human, bot, or other actor. It can login, has a profile
  # and can interact with other members on this and other +Instances+
  class Member
    include EventSourcery::AggregateRoot
    include AggregateEquality
    include Attributes

    def initialize(id, events)
      @tags = []
      super(id, events)
    end

    apply MemberAdded do |event|
      username = event.body['username']
      write_attributes(
        added: true,
        handle: Handle.new(username),
        email: event.body['email'],
        name: event.body['name']
      )
    end

    apply MemberInvited do |event|
    end
    apply FollowerAdded do |event|
    end

    apply MemberBioUpdated do |event|
      write_attributes(event.body.slice('bio'))
    end

    apply MemberNameUpdated do |event|
      write_attributes(event.body.slice('name'))
    end

    apply MemberTagAdded do |event|
      @tags << Tag.new(event.body['tag'])
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

    def update_name(payload)
      new_name = payload.slice('name')
      return self if name == new_name['name'].to_s

      apply_event(MemberNameUpdated, aggregate_id: id, body: new_name)
      self
    end

    def add_tag(payload)
      body = payload.slice('author_id', 'tag')
      apply_event(MemberTagAdded, aggregate_id: id, body: body)
      self
    end

    attr_reader :id

    def active?
      attributes.fetch(:added, false)
    end

    def null?
      false
    end

    def member_id
      id
    end

    def bio
      attributes[:bio]
    end

    def name
      attributes[:name]
    end

    def handle
      attributes[:handle]
    end

    def email
      attributes[:email]
    end

    def invitation_token
      id
    end

    # TODO: implement per-author tags
    def tags_for(_member)
      tags
    end

    private

    attr_reader :tags
  end
end
