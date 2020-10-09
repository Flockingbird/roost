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
      members.each do |member_attributes|
        command = Roost::Commands::Member::AddMember::Command.new(member_attributes)
        Roost::Commands::Member::AddMember::CommandHandler.new.handle(command)
      end
    end

    def process_events
      Roost.event_source.each_by_range(0, 1) do |event|
        esps.each { |ep| ep.process(event) }
      end
    end

    private

    ## TODO call test_obj.class.method_defined?(:members) instead.
    def members
      [
        {
          aggregate_id: SecureRandom.uuid,
          name: 'Harry Potter',
          email: 'harry@example.com'
        }
      ]
    end

    def esps
      @esps ||= [Roost::Projections::Members::Projector.new]
    end
  end
end
