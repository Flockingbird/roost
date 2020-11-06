# frozen_string_literal: true

require 'app/aggregates/registration'

module Commands
  module Registration
    module NewRegistration
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
        # NewRegistration builds a UUIDv5 based on the mailaddress.
        def initialize(params)
          @payload = defaults.merge(params).slice(*defaults.keys)
          @aggregate_id = aggregate_id
        end

        def validate
          super
          # TODO: validate email, name, password
        end

        def aggregate_id
          @aggregate_id ||= Aggregates::Registration.aggregate_id_for_email(
            payload['email']
          )
        end

        private

        def defaults
          {
            'email' => '',
            'name' => '',
            'password' => ''
          }.freeze
        end
      end

      ##
      # CommandHandler for +InviteMember+ Commands
      class CommandHandler < RegistrationCommandHandler
        private

        def apply(aggregate, payload)
          aggregate.request(payload)
          aggregate
        end
      end
    end
  end
end
