# frozen_string_literal: true

module Projections
  module Members
    # Query the Members projection with helpers that return
    # Sequel collection objects.
    class Query
      def self.find(id)
        collection[member_id: id]
      end

      def self.collection
        @collection ||= Roost.projections_database[:members]
      end
    end
  end
end
