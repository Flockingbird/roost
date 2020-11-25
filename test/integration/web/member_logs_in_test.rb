# frozen_string_literal: true

require 'test_helper'

class MemberLogsInTest < Minitest::WebSpec
  describe 'registered user' do
    before do
      @workflow = member_registers
      @workflow.upto(:confirmed)
      # TODO: once confirmed, aren't we logged in already?

      visit '/'
      click_link 'Login'
    end

    it 'logs in using credentials set at test' do
      fill_in('Username', with: @workflow.form_attributes[:username])
      fill_in('Password', with: @workflow.form_attributes[:password])
      click_button('Login')

      assert_content(
        find('h2.title'),
        'Your contacts'
      )
    end

    it 'attempts to login using wrong password' do
      fill_in('Username', with: @workflow.form_attributes[:username])
      fill_in('Password', with: 'pure-blood')
      click_button('Login')

      assert_content(
        find('.notification.is-error'),
        'Could not log in. Is the username and password correct?'
      )
    end

    it 'attempts to login using wrong username' do
      # leave the form empty
      click_button('Login')

      assert_content(
        find('.notification.is-error'),
        'Could not log in. Is the username and password correct?'
      )
    end
  end
end
