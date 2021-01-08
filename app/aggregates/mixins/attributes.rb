# frozen_string_literal: true

module Aggregates
  ##
  # Generic aggregate behaviour
  module Attributes
    def write_attributes(new_attributes)
      attributes.merge!(new_attributes.transform_keys(&:to_sym))
    end

    def attributes
      @attributes ||= Hash.new('').merge(aggregate_id: id)
    end

    def to_h
      attributes
    end
  end
end
