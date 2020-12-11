# frozen_string_literal: true

require 'app/projections/members/query'

module Workflows
  ##
  # Workflow to discover members on this instance
  class DiscoversMember < Base
    def profile_visited
      # TODO: replace by actual searching, or clicking through existing contacts
      # or some other simple way that a user might realisticly discover members
      visit "/m/@#{form_attributes[:username]}@example.com"
      assert_equal(page.status_code, 200)
    end

    private

    def steps
      %i[profile_visited].freeze
    end
  end
end
