# frozen_string_literal: true

require 'test_helper'
require 'app/aggregates/member/tag.rb'

module Aggregates
  class Member
    ##
    # Test Tag module under Member Aggregate
    class TagTest < Minitest::Spec
      let(:harry_author) { fake_uuid(Aggregates::Member, 1) }
      let(:ron_author) { fake_uuid(Aggregates::Member, 2) }
      let(:subject) { Tag.new('friend', harry_author) }

      it 'makes authors from passed in author' do
        assert_equal([harry_author], subject.authors)
      end

      it 'is equal when names are equal' do
        assert(subject == Tag.new('friend', harry_author))
      end

      it 'is equal when names are equal but authors are not' do
        assert(subject == Tag.new('friend', ron_author))
      end

      it 'is comparable to nil' do
        refute_equal(nil, subject)
      end

      it 'appends authors on merge' do
        assert_equal(
          [harry_author, ron_author],
          subject.merge(Tag.new('friend', ron_author)).authors
        )
      end

      it 'by? reports true when author is amoungs authors' do
        assert(subject.by?(harry_author))
        refute(subject.by?(ron_author))
      end
    end
  end
end
