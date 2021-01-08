# frozen_string_literal: true

##
# Allows aggregates and aggregate-alikes (like decorators) to match
# the objects
module AggregateEquality
  def ==(other)
    return false if id.nil?

    id == other.id
  end
end
