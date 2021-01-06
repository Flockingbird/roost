# frozen_string_literal: true

module Workflows
  ##
  # Workflow to tag another members' profile.
  class TagsMember < Base
    def tag_added
      within '.tags' do
        click_icon('plus')
      end

      within 'form' do
        fill_in 'Add your own', with: form_attributes[:tag]
        click_icon('plus')
      end

      process_events(%w[tag_added])
    end

    def form_attributes
      {
        tag: 'friend'
      }.merge(@form_attributes)
    end

    private

    def steps
      %i[tag_added].freeze
    end
  end
end
