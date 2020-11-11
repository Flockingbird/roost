# frozen_string_literal: true

module Workflows
  ##
  # Common workflow generics
  class Base < SimpleDelegator
    attr_reader :test_obj

    def initialize(test_obj, form_attributes = {})
      @form_attributes = form_attributes
      super(test_obj)
    end

    def upto(final_step)
      retval = nil

      steps[0..steps.index(final_step)].each do |current_step|
        retval = send(current_step)
      end

      retval
    end
  end
end
