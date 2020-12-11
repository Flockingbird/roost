# frozen_string_literal: true

require 'test_helper'

##
# As a member using the web-app
# When another member has a profile
# And I visit that profile
# Then I see the public information by that other member
class ViewsProfileTest < Minitest::WebSpec
  it 'cannot view nonexisting members' do
    visit '/m/@doesnotexist@example.com'
    assert_equal(page.status_code, 404)
    assert_content(page, 'not found')
  end
end
