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
        column :username, :text
        column :password, :text
      end

      project MemberAdded do |event|
        username = event.body['username']

        table.insert(
          member_id: event.aggregate_id,
          handle: Handle.new(username).to_s,
          username: username,
          password: event.body['password']
        )
      end
    end
  end
end
