# frozen_string_literal: true

require 'app/aggregates/member'

module Commands
  module Member
    module AddMember
      ##
      # Command to add a new +Member+
      class Command
        attr_reader :aggregate_id, :payload

        def initialize(params)
          @aggregate_id = params.delete(:aggregate_id)
          @payload = params # Select the parameters you want to allow
        end

        def validate
          # Add validation here
        end
      end

      ##
      # CommandHandler for +AddMember+ Commands
      class CommandHandler
        def initialize(repository: Roost.repository)
          @repository = repository
        end

        def handle(command)
          command.validate

          aggregate = repository.load(
            Aggregates::Member,
            command.aggregate_id
          )
          aggregate.add_member(command.payload)
          repository.save(aggregate)
        end

        private

        attr_reader :repository
      end
    end
  end
end
