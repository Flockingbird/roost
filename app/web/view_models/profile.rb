# frozen_string_literal: true

require 'lib/aggregate_equality'

module ViewModels
  ##
  # A Member Profile view model
  class Profile < SimpleDelegator
    include AggregateEquality

    def self.from_collection(collection)
      collection.map { |obj| build(obj) }
    end

    def self.build(obj = nil)
      case obj
      when NilClass
        NullProfile.new if obj.nil?
      when Hash
        new(OpenStruct.new(obj))
      else
        new(obj)
      end
    end

    def updated_on
      updated_at.to_date
    end

    def updated_at
      super || NullDateTime.new('never')
    end

    def null?
      false
    end

    ##
    # Standin for empty profile
    class NullProfile < NullObject
      def name
        placeholder
      end

      def handle
        Handle.new(placeholder)
      end

      def updated_on
        updated_at.to_date
      end

      def updated_at
        NullDateTime.new('never')
      end
    end
  end
end
