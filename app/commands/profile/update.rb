# frozen_string_literal: true

require 'app/aggregates/registration'

module Commands
  module Profile
    module Update
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
      end

      # Handler for Profile::Update::Command
      class CommandHandler < ApplicationCommandHandler
        ##
        # Overridden from ApplicationCommandHandler because we want
        # to call multiple methods on the aggregate root, based
        # on conditions
        def handle
          command.validate

          applied_aggregate = aggregate.update_bio(payload).update_name(payload)

          repository.save(applied_aggregate)
          applied_aggregate
        end

        def aggregate_class
          Aggregates::Member
        end

        def payload
          command.payload
        end
      end
    end
  end
end
