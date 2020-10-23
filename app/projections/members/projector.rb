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
        column :name, :text
        column :email, :text
      end

      project MemberAdded do |event|
        table.insert(
          member_id: event.aggregate_id,
          name: event.body['name'],
          email: event.body['email']
        )
      end
    end
  end
end
