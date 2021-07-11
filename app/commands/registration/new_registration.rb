# frozen_string_literal: true

require 'app/aggregates/registration'
require 'bcrypt'

module Commands
  module Registration
    module NewRegistration
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
        include BCrypt

        REQUIRED_PARAMS = %w[email handle password].freeze
        ALLOWED_PARAMS = REQUIRED_PARAMS

        # NewRegistration builds a UUIDv5 based on the mailaddress.
        def initialize(params)
          @payload = params.slice(*ALLOWED_PARAMS)

          # overwrite the password
          unless (@payload['password'] || '').empty?
            @payload['password'] = Password.create(@payload.delete('password'))
          end

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
          UUIDGen::NS_EMAIL
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
