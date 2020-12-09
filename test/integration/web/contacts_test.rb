# frozen_string_literal: true

require 'test_helper'

##
# As a member using the web-app
# When I visit another members' profile
# And I click the "add to contacts" button
# Then the member is added to my contacts
class MemberAddsToContactsTest < Minitest::WebSpec
  before { harry && ron }

  it 'adds another member to contacts' do
    as(harry) do
      # TODO: when the workflow supports actual discovery, use the
      # visible name and not the username here.
      discover_member(username: ron[:username]).upto(:profile_visited)
      adds_contact.upto(:contact_added)

      # NOTE that the handle uses .com and rons email .org
      assert_content(
        flash(:success),
        'ron@example.com was added to your contacts'
      )

      visit '/contacts'
      assert_content('ron@example.com')
    end
  end

  it 'gets a notification when someone added me as a contact' do
    as(harry) do
      discover_member(username: ron[:username]).upto(:profile_visited)
      adds_contact.upto(:contact_added)
    end

    as(ron) do
      main_menu('Updates').click
      assert_content "hpotter@example.com #{Date.today}"
      # Until harry has changed their name, we render their handle
      assert_content 'hpotter@example.com added you to their contacts'
    end
  end

  it 'cannot add itself to contacts'
  it 'can add a contact only once'
  it 'can only add a contact when logged in'
end
