# frozen_string_literal: true

require 'test_helper'
require_relative '../support/workflows/member_registers'

class VisitorRegistersTest < Minitest::WebSpec
  describe 'with open registrations' do
    it 'sends an email' do
      Workflows::MemberRegisters.new(self).upto(:registered)

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
      Workflows::MemberRegisters.new(self).upto(:confirmed)

      assert_content(
        find('.notification'),
        'Email address confirmed. Welcome!'
      )
    end

    it 'can confirm only once' do
      workflow = Workflows::MemberRegisters.new(self)
      workflow.upto(:confirmed)

      # Confirm again
      workflow.confirmed

      assert_content(
        find('.notification.is-error'),
        'Could not confirm. Maybe the link in the email expired, or was'\
        ' already used?'
      )
    end
  end

  describe 'with invite-only' do
    before { skip 'implement setting' }
  end

  def email
    Roost.mailer.deliveries.last
  end
end
