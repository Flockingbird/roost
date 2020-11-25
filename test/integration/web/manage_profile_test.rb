# frozen_string_literal: true

require 'test_helper'

class MemberManagesProfileTest < Minitest::WebSpec
  before do
    registers = member_registers
    registers.upto(:confirmed)
    @harry = member_registers.form_attributes
  end

  let(:bio) { 'Fought a snakey guy, now proud father and civil servant' }

  describe 'updates biography' do
    it 'changes the public biography' do
      member_logs_in(@harry).upto(:logged_in)
      main_menu('My profile').click
      refute_content bio
      click_icon('pencil')

      fill_in('bio', with: bio)
      click_button('Update')

      process_events(%w[member_bio_updated])

      # Refresh by browsing to page again.
      main_menu('My profile').click
      assert_content bio
    end

    it 'notifies all other members on the instance' do
      ron = { username: 'ron', email: 'ron@example.org', password: 'secret' }
      member_registers(ron).upto(:confirmed)
      member_logs_in(ron).upto(:logged_in)

      member_logs_in(@harry).upto(:logged_in)
      manage_profile.upto(:bio_updated)

      member_logs_in(ron).upto(:logged_in)
      main_menu('Updates').click
      assert_content 'hpotter@example.com'
      assert_content Date.today
      # Until harry has changed their name, we render their handle
      assert_content "hpotter@example.com updated their bio to #{bio}"
    end

    it 'notifies all remote contacts'
  end
end
