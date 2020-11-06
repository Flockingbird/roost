# frozen_string_literal: true

require 'app/aggregates/registration'

module Commands
  module Registration
    module NewRegistration
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
        DEFAULT_PARAMS = {
          'email' => '',
          'name' => '',
          'password' => ''
        }.freeze

        # NewRegistration builds a UUIDv5 based on the mailaddress.
        def initialize(params)
          @payload = DEFAULT_PARAMS.merge(params).slice(*DEFAULT_PARAMS.keys)
          @aggregate_id = aggregate_id
        end

        def aggregate_id
          @aggregate_id ||= Aggregates::Registration.aggregate_id_for_email(
            payload['email']
          )
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
