# frozen_string_literal: true

module Workflows
  ##
  # Workflow to add a contact from a profile of a user
  class AddsContact < Base
    def contact_added
      click_icon('account-plus')

      process_events(%w[contact_added])
    end

    private

    def steps
      %i[contact_added].freeze
    end
  end
end
