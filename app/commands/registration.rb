# frozen_string_literal: true

module Commands
  module Registration
    ##
    # CommandHandler for RegistrationCommands. Loads aggregate root, applies a
    # action to it and saves it again. Specific commands can define what
    # action to take against the aggregate
    class RegistrationCommandHandler < ApplicationCommandHandler
      def handle(command)
        command.validate

        aggregate = repository.load(
          Aggregates::Registration, command.aggregate_id
        )
        aggregate = apply(aggregate, command.payload)
        repository.save(aggregate)
      end

      private

      attr_reader :repository

      def apply(aggregate, payload)
        raise NotImplementedError
      end
    end
  end
end
