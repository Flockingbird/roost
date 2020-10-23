# frozen_string_literal: true

module Roost
  module Projections
    module Invitations
      ##
      # Stores Members in their distinct query table
      class Projector
        include EventSourcery::Postgres::Projector

        projector_name :invitations

        table :invitations do
          column :name, :text
          column :email, :text
        end
      end
    end
  end
end
