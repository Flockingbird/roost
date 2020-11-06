# frozen_string_literal: true

module Workflows
  ##
  # Common workflow generics
  class Base < SimpleDelegator
    attr_reader :test_obj

    def upto(final_step)
      retval = nil

      steps[0..steps.index(final_step)].each do |current_step|
        retval = send(current_step)
      end

      retval
    end
  end
end
