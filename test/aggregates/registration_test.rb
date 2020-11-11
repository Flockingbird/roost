# frozen_string_literal: true

module Aggregates
  class RegistrationTest < Minitest::Spec
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
        assert_includes(subject.changes.map(&:class), RegistrationRequested)
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
      it 'emits RegistrationConfirmed event' do
        subject.confirm(payload)
        assert_includes(subject.changes.map(&:class), RegistrationConfirmed)
      end
    end

    private

    def subject
      @subject ||= Aggregates::Registration.new(
        fake_uuid(Aggregates::Registration, 1), []
      )
    end
  end
end
