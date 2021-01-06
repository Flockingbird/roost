# frozen_string_literal: true

module Aggregates
  class Member
    ##
    # A +Tag+ is an attribute on a +Member+. Each member has 0-N tags. Each tag
    # has 0-N members
    class Tag
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def slug
        name.downcase
      end

      def by?(_expected_author)
        true
      end
    end
  end
end
