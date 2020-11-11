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

    protected

    def uuid_v5
      if aggregate_id_name.empty?
        ''
      else
        UUIDTools::UUID.sha1_create(
          aggregate_id_namespace,
          aggregate_id_name
        ).to_s
      end
    end

    def raise_bad_request(message)
      raise BadRequest, message
    end
  end
end
