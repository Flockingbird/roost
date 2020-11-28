# frozen_string_literal: true

require 'app/aggregates/registration'

module Commands
  module Profile
    module Update
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
      end

      # Handler for Confirm::Command
      class CommandHandler < ApplicationCommandHandler
        ##
        # Overridden from ApplicationCommandHandler because we want
        # to call multiple methods on the aggregate root, based
        # on conditions
        def handle
          command.validate

          applied_aggregate = aggregate.update_bio(command.payload)
                                       .update_name(command.payload)

          repository.save(applied_aggregate)
          applied_aggregate
        end

        def aggregate_class
          Aggregates::Member
        end
      end
    end
  end
end
