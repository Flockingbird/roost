# frozen_string_literal: true

module Workflows
  ##
  # Workflow to log in
  class MemberLogsIn < Base
    def logged_in
      visit_login

      fill_in('Handle', with: form_attributes[:username])
      fill_in('Password', with: form_attributes[:password])
      click_button('Login')

      page
    end

    def form_attributes
      {
        username: 'hpotter',
        password: 'caput draconis'
      }.merge(super)
    end

    private

    def visit_login
      visit '/'
      click_link 'Login'
    end

    def steps
      %i[logged_in].freeze
    end
  end
end
