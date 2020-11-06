# frozen_string_literal: true

module Commands
  ##
  # Base Application Command.
  class ApplicationCommand
    attr_reader :aggregate_id, :payload

    def initialize(params)
      @aggregate_id = params.delete(:aggregate_id)
      @payload = params # Select the parameters you want to allow
    end

    def validate
      unless @aggregate_id
        raise ArgumentError, 'expected aggregate_id to be set'
      end

      true
    end
  end
end
