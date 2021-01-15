# frozen_string_literal: true

require 'test_helper'
require 'app/aggregates/member/tag_list.rb'

module Aggregates
  class Member
    ##
    # Test TagList model; the collection of tags on a member
    class TagListTest < Minitest::Spec
      let(:friend_by_harry) { Minitest::Mock.new }
      let(:friend_by_ron) { Minitest::Mock.new }
      let(:subject) { TagList.new }

      it 'adds tags through <<' do
        subject << friend_by_harry
        assert_includes(subject, friend_by_harry)
      end

      it 'merges tags who are eql when adding' do
        friend_by_harry.expect(:==, true, [friend_by_ron])
        friend_by_harry.expect(:==, true, [friend_by_ron])

        friend_by_harry.expect(:merge, friend_by_harry, [friend_by_ron])

        subject << friend_by_harry
        subject << friend_by_ron
        assert_equal(1, subject.length)
        friend_by_harry.verify
      end

      # TODO: implement limits.
      # TODO: implement ordering.
    end
  end
end
