# frozen_string_literal: true

require 'app/aggregates/member'

module Commands
  module Member
    module AddMember
      ##
      # Command to add a new +Member+
      class Command < ApplicationCommand
        def validate
          # noop
        end
      end

      ##
      # CommandHandler for +AddMember+ Commands
      class CommandHandler < MemberCommandHandler
        private

        def apply(aggregate, payload)
          aggregate.add_member(payload)
          aggregate
        end
      end
    end
  end
end
