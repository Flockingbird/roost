# frozen_string_literal: true

module Commands
  module Member
    ##
    # CommandHandler for MemberCommands. Loads aggregate root, applies a
    # action to it and saves it again. Specific commands can define what
    # action to take against the aggregate
    class MemberCommandHandler < ApplicationCommandHandler
      def handle(command)
        command.validate

        aggregate = repository.load(Aggregates::Member, command.aggregate_id)
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
