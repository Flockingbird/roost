# frozen_string_literal: true

require 'test_helper'

module Aggregates
  ##
  # Unit test for the more complex logic in Registration Aggregate
  class RegistrationTest < Minitest::Spec
    let(:id) { fake_uuid(Aggregates::Registration, 1) }

    subject do
      Aggregates::Registration.new(id, [])
    end

    let(:payload) do
      {
        username: 'hpotter',
        password: 'caput draconis',
        email: 'hpotter@hogwards.edu.wiz'
      }
    end

    describe 'request' do
      before { subject.request(payload) }

      it 'emits RegistrationRequested event' do
        assert_aggregate_has_event(RegistrationRequested)
      end

      it 'sets username' do
        assert_equal(subject.username, 'hpotter')
      end

      it 'sets email' do
        assert_equal(subject.email, 'hpotter@hogwards.edu.wiz')
      end

      it 'sets password' do
        assert_equal(subject.password, 'caput draconis')
      end
    end

    describe 'confirm' do
      before do
        subject.request(payload)
        subject.confirm({})
      end

      it 'emits RegistrationConfirmed event' do
        assert_aggregate_has_event(RegistrationConfirmed)
      end

      it 'adds username email and password to event' do
        assert_equal(
          payload.transform_keys(&:to_s).merge('aggregate_id' => id),
          subject.changes.last.body
        )
      end
    end
  end
end
