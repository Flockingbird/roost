# frozen_string_literal: true

##
# Helpers for testing events.
module EventHelpers
  def assert_aggregate_has_event(klass)
    assert_includes(subject.changes.map(&:class), klass)
  end

  def refute_aggregate_has_event(klass)
    refute_includes(subject.changes.map(&:class), klass)
  end

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
    processors.map do |processor|
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
    @processors ||= Roost.all_processors.map(&:new)
  end
end
