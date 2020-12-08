# frozen_string_literal: true

module Projections
  module Contacts
    # Query the Contacts projection; join to enrich with Members
    class Query
      def self.for_member(id)
        collection.where(owner_id: id).inner_join(:members, handle: :handle)
      end

      def self.collection
        @collection ||= Roost.projections_database[:contacts]
      end
    end
  end
end
