# frozen_string_literal: true

require 'test_helper'

module Aggregates
  ##
  # Unit test for session aggregate root
  class SessionTest < Minitest::Spec
    let(:member_id) { fake_uuid(Aggregates::Member, 1) }
    let(:payload) do
      {
        'username' => 'hpotter',
        'password' => 'hashed',
        'member_id' => member_id
      }
    end

    subject { Aggregates::Session.new(fake_uuid(Aggregates::Session, 1), []) }

    describe '#start' do
      before { subject.start(payload) }
      it 'emits a session_started event' do
        assert_includes(subject.changes.map(&:class), SessionStarted)
      end

      it 'sets member_id' do
        assert_equal(subject.member_id, member_id)
      end
    end
  end
end
