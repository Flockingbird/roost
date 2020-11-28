# frozen_string_literal: true

module Workflows
  ##
  # Workflow to manage the profile of currently logged in member.
  class ManageProfile < Base
    def profile_visited
      main_menu('My profile').click
      page
    end

    def profile_edit_visited
      click_icon('pencil')
      page
    end

    def bio_updated
      fill_in('name', with: name)
      fill_in('bio', with: bio)
      click_button('Update')

      process_events(%w[member_bio_updated member_name_updated])
      page
    end

    private

    def name
      form_attributes[:name]
    end

    def bio
      form_attributes[:bio]
    end

    def steps
      %i[profile_visited profile_edit_visited bio_updated].freeze
    end
  end
end
