# frozen_string_literal: true

require 'test_helper'

require_relative '../support/shared/attribute_behaviour'

module Aggregates
  ##
  # Unit test for the more complex logic in Member Aggregate
  class MemberTest < Minitest::Spec
    include AttributeBehaviour

    subject do
      Aggregates::Member.new(fake_uuid(Aggregates::Member, 1), [])
    end

    it_behaves_as_attribute_setter(:update_bio, 'bio', MemberBioUpdated)
    it_behaves_as_attribute_setter(:update_name, 'name', MemberNameUpdated)
  end
end
