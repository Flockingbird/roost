# frozen_string_literal: true

require 'test_helper'
require 'app/web/view_models/profile'

##
# Test Generic decorator spec
# TODO: move into own lib superclass when appropriate
class ViewModelTest < Minitest::Spec
  it 'handles build with nil as null?' do
    assert(ViewModels::Profile.build(nil).null?)
  end

  it 'handles build with attributes hash' do
    view_model = ViewModels::Profile.build({ name: 'Harry' })
    assert_equal('Harry', view_model.name)
  end

  it 'handles build with aggregate on aggregate_id' do
    id = fake_uuid(Aggregates::Member, 1)
    view_model = ViewModels::Profile.build(OpenStruct.new(aggregate_id: id))
    assert_equal(view_model.aggregate_id, id)
  end
end

##
# Test Profile view model implementation
class ViewModelProfileTest < Minitest::Spec
end
