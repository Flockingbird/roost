# frozen_string_literal: true

require_relative '../../aggregates/registration.rb'

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
        column :email, :text
      end

      project MemberAdded do |event|
        table.insert(
          member_id: event.aggregate_id,
          name: event.body['name'],
          email: event.body['email']
        )
      end

      project RegistrationConfirmed do |event|
        registration = Roost.repository.load(
          Aggregates::Registration,
          event.aggregate_id
        )
        table.insert(
          member_id: event.aggregate_id,
          username: registration.username,
          password: registration.password,
          email: registration.email,
          name: nil
        )
      end
    end
  end
end
