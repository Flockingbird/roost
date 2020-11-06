# frozen_string_literal: true

require 'app/aggregates/member'

module Commands
  module Member
    module InviteMember
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
      end

      # Handler for InviteMember::Command
      class CommandHandler < ApplicationCommandHandler
        def aggregate_class
          Aggregates::Member
        end

        def aggregate_method
          :invite_member
        end
      end
    end
  end
end
