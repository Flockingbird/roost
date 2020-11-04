# frozen_string_literal: true

require 'app/aggregates/registration'

module Commands
  module Registration
    module Confirm
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
        def validate
          super
          # TODO: validate token
        end
      end

      ##
      # CommandHandler for +Registrat+ Commands
      class CommandHandler < RegistrationCommandHandler
        private

        def apply(aggregate, payload)
          aggregate.confirm(payload)
          aggregate
        end
      end
    end
  end
end
