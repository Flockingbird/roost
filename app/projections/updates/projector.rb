# frozen_string_literal: true

require_relative '../members/query'
require 'app/aggregates/member'

module Projections
  module Updates
    ##
    # Stores the Updates for a member in their distinct query table.
    # Denormalised, so each member has their own copy of the updates meant for
    # them. This makes it easy to manage wrt non-local origins. And it allows
    # for easy, yet performant lookups (no joins needed).
    class Projector
      include EventSourcery::Postgres::Projector

      projector_name :updates

      # From mastodon, as reference:
      #  id                     :bigint(8)        not null, primary key
      #  uri                    :string
      #  text                   :text             default(""), not null
      #  created_at             :datetime         not null
      #  updated_at             :datetime         not null
      #  in_reply_to_id         :bigint(8)
      #  reblog_of_id           :bigint(8)
      #  url                    :string
      #  sensitive              :boolean          default(FALSE), not null
      #  visibility             :integer          default("public"), not null
      #  spoiler_text           :text             default(""), not null
      #  reply                  :boolean          default(FALSE), not null
      #  language               :string
      #  conversation_id        :bigint(8)
      #  local                  :boolean
      #  account_id             :bigint(8)        not null
      #  application_id         :bigint(8)
      #  in_reply_to_account_id :bigint(8)
      #  poll_id                :bigint(8)
      #  deleted_at             :datetime
      #
      # We don't have an ID, but if we need one, it would be distinct for each
      # copy of an update: each member has its own distinct record; so an
      # original update might be stored multiple times in the database: once
      # for every member that can see that update.
      table :updates do
        column :for, 'UUID NOT NULL'
        column :uri, :text
        column :author, :text
        column :author_uri, :text
        column :posted_at, DateTime
        column :text, :text
      end

      project MemberBioUpdated do |event|
        author = Roost.repository.load(Aggregates::Member, event.aggregate_id)
        update = BioUpdateRecord.new(event.body.merge(author: author))

        # Insert a record for each local member.
        Members::Query.collection.select(:member_id).each do |attrs|
          table.insert(
            for: attrs[:member_id],
            author: author.handle.to_s,
            posted_at: DateTime.now,
            text: update.text
          )
        end
      end

      project ContactAdded do |event|
        author = Roost.repository.load(
          Aggregates::Member, event.body['owner_id']
        )
        update = AddedContact.new(event.body.merge(author: author))
        recipient_id = Members::Query.aggregate_id_for(event.body['handle'])

        table.insert(
          for: recipient_id,
          author: author.handle.to_s,
          posted_at: DateTime.now,
          text: update.text
        )
      end

      project FollowerAdded do |event|
        author = Roost.repository.load(
          Aggregates::Member, event.body['follower_id']
        )
        update = FollowsUpdate.new(event.body.merge(author: author))
        recipient_id = event.aggregate_id

        table.insert(
          for: recipient_id,
          author: author.handle.to_s,
          posted_at: DateTime.now,
          text: update.text
        )
      end
    end

    ##
    # Represents a generic Update that can projected
    class UpdateRecord < OpenStruct
      def text
        ''
      end

      def author_name
        return '' unless author

        name = author.name.to_s
        name.empty? ? author.handle : name
      end
    end

    ##
    # Represents an update to someones profile bio that can be projected
    class BioUpdateRecord < UpdateRecord
      def text
        "#{author_name} updated their bio to #{bio}"
      end
    end

    ##
    # Represents an update to someones profile bio that can be projected
    class AddedContact < UpdateRecord
      def text
        "#{author_name} added you to their contacts"
      end
    end

    ##
    # Respresents an update that X is now following you
    class FollowsUpdate < UpdateRecord
      def text
        "#{author_name} started following you"
      end
    end
  end
end
