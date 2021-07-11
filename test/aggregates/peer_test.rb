# frozen_string_literal: true

require 'test_helper'

module Aggregates
  ##
  # Unit test for the more complex logic in Peer Aggregate
  class PeerTest < Minitest::Spec
    let(:applied_events) { [] }
    let(:aggregate_id) { fake_uuid(Aggregates::Peer, 1) }

    let(:subject) { Aggregates::Peer.new(aggregate_id, applied_events) }

    it '.name defaults to "Synching..."' do
      assert_equal('Synching...', subject.name)
    end

    it '.bio defaults to "Synching..."' do
      assert_equal('Synching...', subject.bio)
    end
  end
end
