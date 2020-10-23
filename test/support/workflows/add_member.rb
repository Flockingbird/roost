# frozen_string_literal: true

module Workflows
  class AddMember
    attr_reader :test_obj

    def initialize(test_obj)
      @test_obj = test_obj
    end

    def call
      create_events
      process_events
    end

    def create_events
      command = Roost::Commands::Member::AddMember::Command.new(member_attributes)
      Roost::Commands::Member::AddMember::CommandHandler.new.handle(command)
    end

    def process_events
      Roost.event_source.get_next_from(0, event_types: ['member_added']).each do |event|
        esps.each { |ep| ep.process(event) }
      end
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

    def esps
      @esps ||= [Roost::Projections::Members::Projector.new]
    end
  end
end
