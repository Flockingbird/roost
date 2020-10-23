# frozen_string_literal: true

require 'app/aggregates/member'

module Commands
  module Member
    module InviteMember
      ##
      # Command to invite a new +Member+.
      class Command < ApplicationCommand
        def validate
          # noop
        end
      end

      ##
      # CommandHandler for +InviteMember+ Commands
      class CommandHandler < MemberCommandHandler
        private

        attr_reader :repository

        def apply(aggregate, payload)
          aggregate.invite_member(payload)
          aggregate
        end
      end
    end
  end
end
