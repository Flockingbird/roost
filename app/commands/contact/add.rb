# frozen_string_literal: true

require 'app/aggregates/contact'

module Commands
  module Contact
    module Add
      ##
      # Command to add a new +Member+
      class Command < ApplicationCommand
        UUID_CONTACT_NAMESPACE = UUIDTools::UUID.parse(
          '24b3a7e6-7e74-4651-92cf-003a12087488'
        )
        REQUIRED_PARAMS = %w[handle owner_id].freeze
        ALLOWED_PARAMS = REQUIRED_PARAMS

        def initialize(params)
          @payload = params.slice(*ALLOWED_PARAMS)
          @aggregate_id = aggregate_id
        end

        def aggregate_id
          @aggregate_id ||= uuid_v5
        end

        def validate
          REQUIRED_PARAMS.each do |param|
            if (payload[param] || '').empty?
              raise BadRequest, "#{param} is blank"
            end
          end
        end

        private

        def aggregate_id_name
          payload.fetch('handle', '') + payload.fetch('owner_id', '')
        end

        def aggregate_id_namespace
          UUID_CONTACT_NAMESPACE
        end
      end

      # Handler for AddMember::Command
      class CommandHandler < ApplicationCommandHandler
        def aggregate_class
          Aggregates::Contact
        end

        def aggregate_method
          :add
        end
      end
    end
  end
end
