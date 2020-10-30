# frozen_string_literal: true

require 'test_helper'

class VisitorRegistersTest < Minitest::WebSpec
  before do
    visit '/'
    click_link 'Register'
    assert_equal(page.status_code, 200)
    Roost.mailer.deliveries.clear
  end

  describe 'with open registrations' do
    it 'sends an email' do
      fill_in('Username', with: 'hpotter')
      fill_in('Password', with: 'caput draconis')
      fill_in('Email', with: 'harry@example.com')

      click_button('Register')

      assert_content(
        find('.notification'),
        'Registration email sent. Please check your spam folder too'
      )

      process_events

      assert_equal(1, Roost.mailer.deliveries.length)
      assert_includes(email.to, 'harry@example.com')
      assert_match(
        /Welcome to Flockingbird. Please confirm your email address/,
        email.subject
      )
      assert_match(%r{http.*/confirmation/[0-9A-Z]+}, email.body.to_s)
    end
  end

  describe 'with invite-only' do
    before { skip 'implement setting' }
  end

  def email
    Roost.mailer.deliveries.last
  end

  def process_events
    events.each do |event|
      esps.each { |ep| ep.process(event) }
    end
  end

  def events
    Roost.event_store.get_next_from(0, event_types: ['registration_requested'])
  end

  def esps
    @esps ||= [Reactors::ConfirmationMailer.new]
  end
end
