# frozen_string_literal: true

module Aggregates
  class RegistrationTest < Minitest::Spec
    describe 'request' do
      let(:payload) { {} }
      it 'emits RegistrationRequested event' do
        subject.request(payload)
        assert_includes(subject.changes.map(&:class), RegistrationRequested)
      end
    end

    private

    def aggregate_id
      @aggregate_id ||= fake_uuid
    end

    def subject
      @subject ||= Aggregates::Registration.new(aggregate_id, [])
    end
  end
end
