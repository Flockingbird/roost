# frozen_string_literal: true

require 'test_helper'

##
# As a member using the web-app
# When I visit another members' profile
# And I click the "add to contacts" button
# Then the member is added to my contacts
class MemberAddsToContactsTest < Minitest::WebSpec
  before do
    harry
    ron

    as(harry)
    discover_member(username: ron[:username]).upto(:profile_visited)
    adds_contact.upto(:contact_added)
  end

  it 'adds another member to contacts' do
    # NOTE that the handle uses .com and rons email .org
    assert_content(
      flash(:success),
      'ron@example.com was added to your contacts'
    )

    visit '/contacts'
    assert_content('ron@example.com')
  end

  it 'gets a notification when someone added me as a contact' do
    as(ron) do
      main_menu('Updates').click
      assert_content "hpotter@example.com #{Date.today}"
      # Until harry has changed their name, we render their handle
      assert_content 'hpotter@example.com added you to their contacts'
    end
  end

  it 'can add a contact only once' do
    # Ran in before, run again.
    discover_member(username: ron[:username]).upto(:profile_visited)
    adds_contact.upto(:contact_added)

    assert_content(
      flash(:error),
      'Contact is already added'
    )
  end

  it 'cannot add itself to contacts' do
    discover_member(username: harry[:username]).upto(:profile_visited)
    refute_selector(icon_selector('account-plus'))

    carry_cookie_from_cap
    # send the request manually. 1337h4xOr skills.
    post '/contacts', { handle: "@#{harry[:username]}@example.com" }
    assert_equal(403, last_response.status)
  end
end
