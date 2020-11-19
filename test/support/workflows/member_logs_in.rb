# frozen_string_literal: true

module Workflows
  class MemberLogsIn < Base
    def logged_in
      visit '/'
      click_link 'Login'

      fill_in('Username', with: form_attributes[:username])
      fill_in('Password', with: form_attributes[:password])
      click_button('Login')
      page
    end

    def form_attributes
      {
        username: 'hpotter',
        password: 'caput draconis'
      }.merge(@form_attributes)
    end

    private

    def steps
      %i[logged_in].freeze
    end
  end
end
