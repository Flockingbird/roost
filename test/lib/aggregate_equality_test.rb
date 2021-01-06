# frozen_string_literal: true

require 'test_helper'

##
# Test Mock
class TestFakeAggregate
  include AggregateEquality
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end
end

##
# Test the AggregateEquality module
class AggregateEqualityTest < Minitest::Spec
  it 'is equal when ids are equal' do
    id = fake_uuid(Aggregates::Member, 1)
    assert_equal(
      TestFakeAggregate.new(id, 'harry'),
      TestFakeAggregate.new(id, 'ron')
    )
  end

  it 'it not equal when both ids are nil' do
    refute_equal(
      TestFakeAggregate.new(nil, 'harry'),
      TestFakeAggregate.new(nil, 'ron')
    )
  end
end
