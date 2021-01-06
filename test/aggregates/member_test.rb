# frozen_string_literal: true

require 'test_helper'

require_relative '../support/shared/attribute_behaviour'

module Aggregates
  ##
  # Unit test for the more complex logic in Member Aggregate
  class MemberTest < Minitest::Spec
    include AttributeBehaviour

    let(:id) { fake_uuid(Aggregates::Member, 1) }

    subject do
      Aggregates::Member.new(id, [])
    end

    it_behaves_as_attribute_setter(:update_bio, 'bio', MemberBioUpdated)
    it_behaves_as_attribute_setter(:update_name, 'name', MemberNameUpdated)

    it_sets_attribute(:add_member, 'email')
    it_sets_attribute(:add_member, 'name')
    it 'add_member sets handle from username' do
      subject.add_member('username' => 'harry')
      assert_equal(subject.handle, Handle.new('harry'))
    end

    it 'MemberAdded sets added attribute to true' do
      assert(Aggregates::Member.new(id, [MemberAdded.new]).attributes[:added])
    end

    it 'to_h returns attributes' do
      assert_equal({ aggregate_id: id }, subject.to_h)
    end

    describe 'active?' do
      it 'is true when added is true' do
        assert(Aggregates::Member.new(id, [MemberAdded.new]).active?)
      end
    end
  end
end
