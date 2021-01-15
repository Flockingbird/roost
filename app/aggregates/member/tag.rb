# frozen_string_literal: true

module Aggregates
  class Member
    ##
    # A +Tag+ is an attribute on a +Member+. Each member has 0-N tags. Each tag
    # has 0-N members
    class Tag
      attr_reader :name

      def initialize(name, author)
        @name = name
        @authors = Set[author]
      end

      def slug
        name.downcase
      end

      def authors
        @authors.to_a
      end

      def by?(expected_author)
        @authors.include?(expected_author)
      end

      def ==(other)
        return if other.nil?

        name == other.name
      end

      def merge(other)
        @authors += other.authors
        self
      end
    end
  end
end
