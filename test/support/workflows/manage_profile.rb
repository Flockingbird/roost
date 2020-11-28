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
      fill_in('name', with: form_attributes[:name]) if form_attributes[:name]
      fill_in('bio', with: form_attributes[:bio]) if form_attributes[:bio]
      click_button('Update')

      process_events(%w[member_bio_updated member_name_updated])
      page
    end

    private

    def steps
      %i[profile_visited bio_updated].freeze
    end
  end
end
