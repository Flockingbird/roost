# frozen_string_literal: true

require 'test_helper'

class VisitorRegistersTest < Minitest::WebSpec
  describe 'with open registrations' do
    it 'sends an email' do
      member_registers.upto(:registered)

      assert_content(
        find('.notification'),
        'Registration email sent. Please check your spam folder too'
      )

      assert_mail_deliveries(1)
      assert_includes(email.to, 'harry@hogwards.edu.wiz')
      assert_match(
        /Welcome to Flockingbird. Please confirm your email address/,
        email.subject
      )
      assert_match(%r{http.*/confirmation/[0-9a-f-]+}, email.body.to_s)
    end

    it 'confirms the email by clicking the link in the email' do
      member_registers.upto(:confirmed)

      assert_content(
        find('.notification'),
        'Email address confirmed. Welcome!'
      )
    end

    it 'can register only once per email address' do
      workflow = member_registers
      workflow.upto(:registered)
      assert_mail_deliveries(1)

      workflow.upto(:registered)
      assert_mail_deliveries(1) # Still one, no new mails

      assert_content(
        find('.notification.is-error'),
        'Emailaddress is already registered. Do you want to login instead?'\
      )
    end

    it 'can confirm only once' do
      workflow = member_registers
      workflow.upto(:confirmed)

      # Confirm again
      workflow.confirmed

      assert_content(
        find('.notification.is-error'),
        'Could not confirm. Maybe the link in the email expired, or was'\
        ' already used?'
      )
    end

    it 'must provide all attributes' do
      # We only test with a missing username
      member_registers({ username: '' }).upto(:registered)

      assert_content(
        find('.notification.is-error'),
        'username is blank'\
      )
    end
  end

  describe 'with invite-only' do
    before { skip 'implement setting' }
  end

  def email
    deliveries.last
  end
end
