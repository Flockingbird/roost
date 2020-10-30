# frozen_string_literal: true

require 'app/aggregates/registration'

module Commands
  module Registration
    module NewRegistration
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
        def validate
          super
          # TODO: validate email, name, password
        end
      end

      ##
      # CommandHandler for +InviteMember+ Commands
      class CommandHandler < RegistrationCommandHandler
        private

        attr_reader :repository

        def apply(aggregate, payload)
          aggregate.request(payload)
          aggregate
        end
      end
    end
  end
end
