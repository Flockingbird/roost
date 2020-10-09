# frozen_string_literal: true

module Roost
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
      end
    end
  end
end
