# frozen_string_literal: true

module Aggregates
  ##
  # Generic aggregate behaviour
  module Attributes
    attr_reader :attributes

    def initialize(*arguments)
      @attributes = Hash.new('')
      super(*arguments)
    end

    def write_attributes(attributes)
      @attributes.merge!(attributes.transform_keys(&:to_sym))
    end
  end
end
