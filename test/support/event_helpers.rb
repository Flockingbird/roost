# frozen_string_literal: true

##
# Helpers for testing events.
module EventHelpers
  def last_event(aggregate_id = nil)
    unless aggregate_id
      event_id = Roost.event_store.latest_event_id
      aggregate_id = Roost.event_store.get_next_from(event_id).last.aggregate_id
    end

    Hours.event_store.get_events_for_aggregate_id(aggregate_id).last
  end

  def projector_process_event(aggregate_id)
    projectors.each do |projector|
      event = last_event(aggregate_id)
      projector.process(event)
    end
  end

  def setup_projectors
    projectors.each(&:setup)
  end

  protected

  def projectors
    @projectors = [
      Roost::Projections::Invitations::Projector.new
    ]
  end
end
