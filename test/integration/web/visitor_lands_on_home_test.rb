# frozen_string_literal: true

require 'test_helper'

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
