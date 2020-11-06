# frozen_string_literal: true

##
# Helpers for testing events.
module EventHelpers
  def last_event(aggregate_id = nil)
    unless aggregate_id
      event_id = event_store.latest_event_id
      aggregate_id = event_store.get_next_from(event_id).last.aggregate_id
    end

    event_store.get_events_for_aggregate_id(aggregate_id).last
  end

  def setup_processors
    processors.each(&:setup)
  end

  def process_events(event_types)
    processors.each do |processor|
      events = event_store.get_next_from(
        (processor.last_processed_event_id + 1),
        event_types: event_types
      )

      events.each do |ev|
        processor.process(ev)
        Roost.tracker.processed_event(processor.processor_name, ev.id)
      end
    end
  end

  protected

  def event_store
    Roost.event_store
  end

  def processors
    @processors ||= [
      Projections::Invitations::Projector.new,
      Projections::Members::Projector.new,
      Reactors::ConfirmationMailer.new,
      Reactors::InvitationMailer.new
    ]
  end
end
