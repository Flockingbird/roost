# frozen_string_literal: true

require 'test_helper'

module Aggregates
  ##
  # Unit test for the more complex logic in Contact Aggregate
  class ContactTest < Minitest::Spec
    subject do
      Aggregates::Contact.new(fake_uuid(Aggregates::Contact, 1), [])
    end

    let(:owner_id) { fake_uuid(Aggregates::Member, 1) }

    describe '#add' do
      let(:payload) { { owner_id: owner_id, handle: '@ron@example.org' } }

      it 'can only be added once' do
        subject.add(payload)
        assert_raises(UnprocessableEntity) do
          subject.add(payload)
        end
      end
    end
  end
end
