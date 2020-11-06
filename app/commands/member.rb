# frozen_string_literal: true

module Commands
  module Member
    ##
    # CommandHandler for MemberCommands. Loads aggregate root, applies a
    # action to it and saves it again. Specific commands can define what
    # action to take against the aggregate
    class MemberCommandHandler < ApplicationCommandHandler
      private

      attr_reader :repository

      def apply(aggregate, payload)
        raise NotImplementedError
      end

      def aggregate(aggregate_id)
        repository.load(Aggregates::Member, aggregate_id)
      end
    end
  end
end
