# frozen_string_literal: true

module Commands
  module Registration
    ##
    # CommandHandler for RegistrationCommands. Loads aggregate root, applies a
    # action to it and saves it again. Specific commands can define what
    # action to take against the aggregate
    class RegistrationCommandHandler < ApplicationCommandHandler
      private

      attr_reader :repository

      def apply(aggregate, payload)
        raise NotImplementedError
      end

      def aggregate(aggregate_id)
        repository.load(Aggregates::Registration, aggregate_id)
      end
    end
  end
end
