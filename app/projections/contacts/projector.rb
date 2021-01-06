# frozen_string_literal: true

require_relative '../members/query'

module Projections
  module Contacts
    ##
    # Stores Contacts as a hash map so we can join the actual members
    class Projector
      include EventSourcery::Postgres::Projector

      projector_name :contacts

      table :contacts do
        column :owner_id, 'UUID NOT NULL'
        column :contact_id, 'UUID NOT NULL'
        column :handle, :text
        column :name, :text
        column :bio, :text
        column :updated_at, DateTime
      end

      project ContactAdded do |event|
        aggregate_id = Members::Query.aggregate_id_for(event.body['handle'])
        contact = Roost.repository.load(Aggregates::Member, aggregate_id)

        table.insert(
          owner_id: event.body['owner_id'],
          contact_id: aggregate_id,
          handle: contact.handle.to_s,
          name: contact.name,
          bio: contact.bio,
          updated_at: Time.now
        )
      end

      project MemberBioUpdated do |event|
        table.where(contact_id: event.aggregate_id)
             .update(bio: event.body['bio'])
      end

      project MemberNameUpdated do |event|
        table.where(contact_id: event.aggregate_id)
             .update(name: event.body['name'])
      end
    end
  end
end
