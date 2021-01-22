# frozen_string_literal: true

module Projections
  module Members
    ##
    # Stores Members in their distinct query table
    class Projector
      include EventSourcery::Postgres::Projector

      projector_name :members

      table :members do
        column :member_id, 'UUID NOT NULL'
        column :handle, :text, null: false
        column :password, :text
      end

      project MemberAdded do |event|
        table.insert(
          member_id: event.aggregate_id,
          handle: event.body['handle'],
          password: event.body['password']
        )
      end
    end
  end
end
