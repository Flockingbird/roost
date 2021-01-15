# frozen_string_literal: true

module Commands
  module Profile
    module Tag
      ##
      # Command to add a Tag
      class Command < ApplicationCommand
      end

      ##
      # Handler for Profile::Tag::Command
      class CommandHandler < ApplicationCommandHandler
        def aggregate_class
          Aggregates::Member
        end

        def aggregate_method
          :add_tag
        end
      end
    end
  end
end
