# frozen_string_literal: true

##
# Generic Null object
class NullObject
  attr_reader :placeholder
  def initialize(placeholder = '')
    @placeholder = placeholder
  end

  def to_s
    placeholder
  end

  def null?
    true
  end
end

##
# Null Object for DateTimes
class NullDateTime < NullObject
  def to_date
    NullDate.new(placeholder)
  end
end

# ##
# Null Object for Dates
class NullDate < NullObject
end
