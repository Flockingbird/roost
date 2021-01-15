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

  it 'shows tags from other members styled different' do
    as(hermoine)
    discover_member(username: ron[:username]).upto(:profile_visited)

    assert_selector('.tag', text: 'friend')
    refute_selector('.tag.mine')
  end

  # TODO: for accountability, we need to show the tag.authors in a neat
  # and friendly hover dialog.
  # Then we can test that a member who tags multiple times, only appears once
  # in the authors. One tag "friend" per author, so to say.

  it 'profile can be tagged multiple times with one tag' do
    as(hermoine)
    discover_member(username: ron[:username]).upto(:profile_visited)
    tags_member.upto(:tag_added)

    # Tags shows up as "mine" but it still appears only once: hpotter and mine
    # are merged. One .tag is used for the "add" button, making total 2.
    assert_selector('.tag.mine', text: 'friend')
    assert_equal(find_all('.tag').length, 2)
  end

  it 'follows the tagged member' do
    # Determine that harry follows ron by checking the notification sent to
    # ron. TODO: Change to check with my followings once we have that overview
    as(ron)

    main_menu('Updates').click
    assert_content '@hpotter@example.com started following you'
  end
end
