# frozen_string_literal: true

require 'test_helper'

##
# As a member using the web-app
# When I visit another members' profile
# And I click the "add to contacts" button
# Then the member is added to my contacts
class FederatedContactsTest < Minitest::WebSpec
  before do
    skip 'implement remote flow first'
    harry
    as(harry)

    # INK: remote_action.
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
end
