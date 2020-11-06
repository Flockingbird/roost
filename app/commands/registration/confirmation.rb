# frozen_string_literal: true

require 'app/aggregates/registration'

module Commands
  module Registration
    module Confirm
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
      end

      # Handler for Confirm::Command
      class CommandHandler < ApplicationCommandHandler
        def aggregate_class
          Aggregates::Registration
        end

        def aggregate_method
          :confirm
        end
      end
    end
  end
end
