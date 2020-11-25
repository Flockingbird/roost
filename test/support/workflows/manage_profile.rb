# frozen_string_literal: true

module Workflows
  ##
  # Workflow to manage the profile of currently logged in member.
  class ManageProfile < Base
    def bio_updated
      main_menu('My profile').click
      click_icon('pencil')

      fill_in('bio', with: bio)
      click_button('Update')

      process_events(%w[member_bio_updated])
      page
    end

    private

    def steps
      %i[bio_updated].freeze
    end
  end
end
