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

  it 'can only add a tag once per tagging member'
  it 'can add a tag multiple times on one profile'

  it 'follows the tagged member' do
    # Determine that harry follows ron by checking the notification sent to
    # ron. TODO: Change to check with my followings once we have that overview
    as(ron)

    # @INK: implementing a follow feature. Which:
    # * sends a notification
    # * introduces a Followers list.
    # * adds me as follower.
    main_menu('Updates').click
    assert_content '@hpotter@example.com started following you'
  end
end
