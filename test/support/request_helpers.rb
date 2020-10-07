# frozen_string_literal: true

module RequestHelpers
  def app
    @app ||= Roost::Server
  end

  def last_event(aggregate_id)
    Roost.event_store
         .get_events_for_aggregate_id(aggregate_id).last
  end
end
