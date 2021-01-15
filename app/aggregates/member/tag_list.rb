# frozen_string_literal: true

module Aggregates
  class Member
    ##
    # A +TagList+ is an ordered Set. Ensuring tags with same names are merged.
    class TagList < Array
      def <<(other)
        if include?(other)
          find_original(other).merge(other)
        else
          super(other)
        end
      end

      private

      def find_original(other)
        find { |tag| tag == other }
      end
    end
  end
end
