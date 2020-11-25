# frozen_string_literal: true

module Workflows
  ##
  # Workflow to manage the profile of currently logged in member.
  class ManageProfile < Base
    def profile_visited
      main_menu('My profile').click
      page
    end

    def bio_updated
      click_icon('pencil')
      fill_in('bio', with: form_attributes[:bio])
      click_button('Update')

      process_events(%w[member_bio_updated])
      page
    end

    private

    def steps
      %i[profile_visited bio_updated].freeze
    end
  end
end
