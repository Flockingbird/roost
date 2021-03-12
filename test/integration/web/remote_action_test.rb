# frozen_string_literal: true

require 'test_helper'

##
# As a member of this.example.com instance
# When I visit other.example.com instance
# And I request an action there
# Then I am am presented with a form for my handle
# And when I fill that form and click "{action}" button
# Then I am redirected to my own instance with the proper payload
# So that I can finalize the action on my own instance
#
# NOTE: {action} is any of (but not limited to), add contact, tag, annotate,
# etc.
class RemoteActionTest < Minitest::WebSpec
  let(:handle) { luna[:handle] }

  it 'adds remote member as contact' do
    landing_path = at(ravenclaw) do
      visit "/m/#{handle}"
      click_icon('account-plus')

      fill_in(
        "Provide your handle to follow #{handle}",
        with: '@harry@example.com'
      )
      click_button('Follow')
      page.current_path
    end

    # Revisit the page to open it with harry as session
    as(harry)
    visit landing_path

    assert_content(page, "As @harry@example.com you want to follow #{handle}")
    click_button('Confirm')
    assert_content(flash(:success), "#{handle} was added to your contacts")

    process_events(%w[contact_fetch_requested contact_added])

    visit '/contacts'
    assert_content(luna[:handle])
  end

  # TODO: handle non-logged in on local.
  # TODO: handle authentication properly with oauth secrets exchange.

  private

  def ravenclaw
    @ravenclaw ||= RemoteInstance.new('ravenclaw.example.org', self)
  end
end
