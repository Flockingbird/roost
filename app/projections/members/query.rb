# frozen_string_literal: true

module Projections
  module Members
    # Query the Members projection with helpers that return
    # Sequel collection objects.
    class Query
      COLLECTION = Roost.projections_database[:members]

      def self.handle
        COLLECTION.all
      end

      def self.find(id)
        COLLECTION[member_id: id]
      end
    end
  end
end
