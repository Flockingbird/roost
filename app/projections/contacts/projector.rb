# frozen_string_literal: true

module Projections
  module Contacts
    ##
    # Stores Contacts as a hash map so we can join the actual members
    class Projector
      include EventSourcery::Postgres::Projector

      projector_name :contacts

      table :contacts do
        column :owner_id, 'UUID NOT NULL'
        column :handle, :text
      end

      project ContactAdded do |event|
        table.insert(
          owner_id: event.body['owner_id'],
          handle: event.body['handle']
        )
      end
    end
  end
end
