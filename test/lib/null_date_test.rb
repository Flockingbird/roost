# frozen_string_literal: true

require 'test_helper'
require 'lib/null_date'

##
# Test the Null Objects
class NullObjectTest < Minitest::Spec
  let(:subject) { NullObject.new('[empty]') }

  describe 'to_s' do
    it 'returns the placeholder' do
      assert_equal(subject.to_s, '[empty]')
    end
  end

  it 'is always null?' do
    assert(subject.null?)
  end
end

##
# Test the Null Dates
class NullDateTimeTest < Minitest::Spec
  let(:subject) { NullDateTime.new('[empty]') }

  describe 'to_date' do
    it 'returns a NullDate placeholder' do
      assert_equal(subject.to_date.to_s, '[empty]')
    end
  end
end
