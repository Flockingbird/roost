# frozen_string_literal: true

module Workflows
  class AddMember < Base
    include EventHelpers

    def call
      create_events
      process_events(%w[member_added])
    end

    def create_events
      command = Commands::Member::AddMember::Command.new(member_attributes)
      Commands::Member::AddMember::CommandHandler.new(command: command).handle
    end

    def member_name
      'Harry Potter'
    end

    def member_email
      'harry@example.com'
    end

    def aggregate_id
      @aggregate_id ||= SecureRandom.uuid
    end

    private

    def member_attributes
      {
        aggregate_id: aggregate_id,
        name: member_name,
        email: member_email
      }
    end
  end
end
