# frozen_string_literal: true

require 'test_helper'

module Aggregates
  ##
  # Unit test for the more complex logic in Member Aggregate
  class MemberTest < Minitest::Spec
    subject do
      Aggregates::Member.new(fake_uuid(Aggregates::Member, 1), [])
    end

    describe '#update_bio' do
      let(:payload) { { 'bio' => 'I am bio' } }

      it 'sets the bio' do
        assert_equal(subject.bio, '')
        subject.update_bio(payload)
        assert_equal(subject.bio, 'I am bio')
      end

      it 'emits a BioUpdated event when the bio changed' do
        subject.update_bio(payload)
        assert_aggregate_has_event(MemberBioUpdated)
      end

      it 'does not emit a BioUpdated event when the bio will not change' do
        subject.update_bio('bio' => subject.bio)

        refute_aggregate_has_event(MemberBioUpdated)
      end
    end

    describe '#update_name' do
      let(:payload) { { 'name' => 'Harry Potter' } }

      it 'sets the name' do
        assert_equal(subject.name, '')
        subject.update_name(payload)
        assert_equal(subject.name, 'Harry Potter')
      end

      it 'emits a NameUpdated event when the name changed' do
        subject.update_name(payload)
        assert_aggregate_has_event(MemberNameUpdated)
      end

      it 'does not emit a NameUpdated event when the name will not change' do
        subject.update_name('name' => subject.name)
        refute_aggregate_has_event(MemberNameUpdated)
      end
    end
  end
end
