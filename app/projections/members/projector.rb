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
        column :username, :text
        column :password, :text
        column :name, :text
        column :bio, :text
        column :email, :text
      end

      project MemberAdded do |event|
        table.insert(
          member_id: event.aggregate_id,
          username: event.body['username'],
          password: event.body['password'],
          name: event.body['name'],
          email: event.body['email']
        )
      end

      project MemberBioUpdated do |event|
        table.where(member_id: event.aggregate_id)
             .update(bio: event.body['bio'])
      end

      project MemberNameUpdated do |event|
        table.where(member_id: event.aggregate_id)
             .update(name: event.body['name'])
      end
    end
  end
end
