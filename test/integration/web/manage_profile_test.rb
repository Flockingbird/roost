# frozen_string_literal: true

require 'test_helper'

##
# As a member using the web-app
# When someone upates their profile
# Then I want to be notified
# So that I know what is happening in my network.
class MemberManagesProfileTest < Minitest::WebSpec
  let(:bio) { 'Fought a snakey guy, now proud father and civil servant' }
  let(:public_name) { 'Harry James Potter' }

  before { harry && ron }

  it 'changes the public biography and name' do
    as(harry) do
      manages = manage_profile(name: public_name, bio: bio)
      manages.upto(:profile_visited)
      refute_content bio
      refute_content public_name

      manages.upto(:profile_updated)

      # Refresh by browsing to page again.
      manages.upto(:profile_visited)
      assert_content bio
      assert_content public_name
    end
  end

  it 'cannot update when not logged in' do
    visit '/profile'
    assert_equal(page.status_code, 403)
    assert_content(page, 'You are not logged in')
    visit '/profile/edit'
    assert_equal(page.status_code, 403)
    assert_content(page, 'You are not logged in')
    # We might want to test that PUT profile does requires authentication,
    # but that is hard to test from the interface, since you cannot get
    # to the form making the PUT without being logged in.
  end

  it 'notifies you and all other members on the instance of bio update' do
    as(harry)
    manage_profile(bio: bio).upto(:bio_updated)
    main_menu('Updates').click
    assert_content 'hpotter@example.com'

    as(ron)
    main_menu('Updates').click
    assert_content "hpotter@example.com #{Date.today}"
    # Until harry has changed their name, we render their handle
    assert_content "hpotter@example.com updated their bio to #{bio}"
  end

  it 'does not notify other members on the instance of name update' do
    as(harry)
    manage_profile(name: public_name).upto(:bio_updated)

    as(ron)
    main_menu('Updates').click
    refute_selector('.update')
  end

  ## TODO implement followers first
  # it 'notifies all remote contacts'
end
