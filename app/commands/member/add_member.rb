# frozen_string_literal: true

require 'app/aggregates/member'

module Commands
  module Member
    module AddMember
      ##
      # Command to add a new +Member+
      class Command < ApplicationCommand
      end

      # Handler for AddMember::Command
      class CommandHandler < ApplicationCommandHandler
        def aggregate_class
          Aggregates::Member
        end

        def aggregate_method
          :add_member
        end
      end
    end
  end
end
