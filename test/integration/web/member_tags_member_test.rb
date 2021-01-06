# frozen_string_literal: true

require 'test_helper'

##
# As a member using the web-app
# When I visit another members' profile
# And I click the "add tag" button
# And I fill provide a tag
# Then the tag is added to that profile
# And I follow the member
class MemberTagsMemberTest < Minitest::WebSpec
  before do
    harry
    ron

    as(harry)
    discover_member(username: ron[:username]).upto(:profile_visited)

    tags_member.upto(:tag_added)
  end

  it 'adds a tag to another profile' do
    assert_content(flash(:success), '@ron@example.com was tagged as "friend"')
    discover_member(username: ron[:username]).upto(:profile_visited)

    assert_selector('.tag.mine', text: 'friend')
  end
end
