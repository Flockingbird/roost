# frozen_string_literal: true

require 'test_helper'

##
# As a member using the web-app
# When someone upates their profile
# Then I want to be notified
# So that I know what is happening in my network.
class MemberManagesProfileTest < Minitest::WebSpec
  let(:bio) { 'Fought a snakey guy, now proud father and civil servant' }
  let(:harry) do
    registers = member_registers
    registers.upto(:confirmed)

    member_registers.form_attributes
  end
  let(:ron) do
    ron = { username: 'ron', email: 'ron@example.org', password: 'secret' }
    member_registers(ron).upto(:confirmed).html

    ron
  end

  before do
    harry
    ron
  end

  it 'changes the public biography' do
    as(harry) do
      manages = manage_profile(bio: bio)
      manages.upto(:profile_visited)
      refute_content bio

      manages.upto(:profile_updated)

      # Refresh by browsing to page again.
      manages.upto(:profile_visited)
      assert_content bio
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
    assert_content 'hpotter@example.com'
    assert_content Date.today
    # Until harry has changed their name, we render their handle
    assert_content "hpotter@example.com updated their bio to #{bio}"
  end

  ## TODO implement followers first
  # it 'notifies all remote contacts'
end
