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
        def aggregate_class
          Aggregates::Member
        end

        def aggregate_method
          :update_bio
        end
      end
    end
  end
end
