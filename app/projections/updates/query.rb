# frozen_string_literal: true

module Projections
  module Updates
    ##
    # Looks up Updates in projection
    class Query
      def self.for_member(member_id)
        collection.where(for: member_id)
      end

      def self.collection
        @collection ||= Roost.projections_database[:updates]
      end
    end
  end
end
