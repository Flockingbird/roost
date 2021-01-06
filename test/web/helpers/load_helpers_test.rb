# frozen_string_literal: true

require 'test_helper'

require 'app/web/helpers/load_helpers'

# Test Mock
class TestFakeController
  include LoadHelpers
end

# Test Mock for a View Model
class TestFakeViewModel
  def initialize(_obj); end
end
# Test Mock for a Null View Model
class TestFakeViewNullModel; end

##
# Test the Load Helpers Mixin
class LoadHelpersTest < Minitest::Spec
  let(:aggregate_id) { fake_uuid(Aggregates::Member, 1) }
  let(:fake_respository) { Minitest::Mock.new }
  let(:subject) { TestFakeController.new }
  let(:aggregate) { OpenStruct.new }

  before do
    @repo = Roost.repository
    Roost.instance_variable_set(:@repository, fake_respository)

    fake_respository.expect(
      :load,
      aggregate,
      [Aggregates::Member, aggregate_id]
    )
  end

  after do
    Roost.instance_variable_set(:@repository, @repo)
  end

  it '#load loads from the Aggregate repository' do
    subject.load(Aggregates::Member, aggregate_id)
    fake_respository.verify
  end

  it '#load does not load when aggregate_id is nil' do
    assert_nil(subject.load(Aggregates::Member, nil))
  end

  it '#decorate decorates the object' do
    assert_kind_of(
      TestFakeViewModel,
      subject.decorate(
        Aggregates::Member.new(aggregate_id, []),
        TestFakeViewModel,
        TestFakeViewNullModel
      )
    )
  end

  it '#decorate decorates object with null view when object is null' do
    assert_kind_of(
      TestFakeViewNullModel,
      subject.decorate(
        nil,
        TestFakeViewModel,
        TestFakeViewNullModel
      )
    )
  end
end
