# frozen_string_literal: true

##
# Loads aggregates from repo with fallbacks to nullobjects
module LoadHelpers
  def load(aggregate_class, aggregate_id)
    return unless aggregate_id

    Roost.repository.load(aggregate_class, aggregate_id)
  end

  def decorate(object, decorator_class, decorator_null_class)
    return decorator_null_class.new unless object

    decorator_class.new(object)
  end
end
