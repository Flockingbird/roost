# frozen_string_literal: true

require 'test_helper'

class MemberManagesProfileTest < Minitest::WebSpec
  before do
    register = Workflows::MemberRegisters.new(self)
    register.upto(:confirmed)
    Workflows::MemberLogsIn.new(self, register.form_attributes).upto(:logged_in)
  end

  let(:bio) { 'Fought a snakey guy, now proud father and civil servant' }

  describe 'updates biography' do
    it 'changes the public biography' do
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

    it 'notifies all members on the instance'
    it 'notifies all remote contacts'
  end
end
