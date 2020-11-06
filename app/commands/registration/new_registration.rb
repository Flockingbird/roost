# frozen_string_literal: true

require 'app/aggregates/registration'

module Commands
  module Registration
    module NewRegistration
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
        UUID_EMAIL_NAMESPACE = UUIDTools::UUID.parse(
          '2282b78c-85d6-419f-b240-0263d67ee6e6'
        )

        REQUIRED_PARAMS = %w[email username password].freeze
        ALLOWED_PARAMS = REQUIRED_PARAMS

        # NewRegistration builds a UUIDv5 based on the mailaddress.
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
          payload['email'] || ''
        end

        def aggregate_id_namespace
          UUID_EMAIL_NAMESPACE
        end
      end

      # Handler for NewRegistration::Command
      class CommandHandler < ApplicationCommandHandler
        def aggregate_class
          Aggregates::Registration
        end

        def aggregate_method
          :request
        end
      end
    end
  end
end
