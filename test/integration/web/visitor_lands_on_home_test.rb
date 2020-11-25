# frozen_string_literal: true

require 'test_helper'

##
# As a visitor
# When I visit the homepage
# Then I see that I can register or login
# So that it is clear what I can do with the app.
class VisitorLandsOnHomeTest < Minitest::WebSpec
  describe 'visitor_lands_on_home' do
    before do
      visit '/'
    end

    it 'has a title and subtitle' do
      assert_title('Flockingbird')
      assert_content('Flockingbird')
      assert_content('Manage your business network.')
    end

    it 'has two buttons' do
      assert_link('Register', class: ['button'])
      assert_link('Login', class: 'button')
    end
  end
end
