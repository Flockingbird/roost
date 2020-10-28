# frozen_string_literal: true

require 'test_helper'
require 'support/workflows/add_member'

class MemberInvitesMemberTest < Minitest::ApiSpec
  describe 'POST /invitations' do
    let(:aggregate_id) { SecureRandom.uuid }
    let(:invitee_email) { 'irene@example.com' }
    let(:invitee_name) { 'Irene' }
    let(:workflow) { Workflows::AddMember.new(self) }

    before do
      workflow.call
      header('Content-Type', 'application/vnd.api+json')
      header('Accept', 'application/vnd.api+json')

      bearer_token = jwt.encode(authentication_payload, secret, 'HS256')
      header('Authorization', "Bearer #{bearer_token}")

      assert_equal Roost.mailer.deliveries.length, 0
    end

    it 'sends an invitation email' do
      post_json(
        "/invitations/#{aggregate_id}",
        {
          data: {
            type: 'invitation',
            attributes: {
              to_email: invitee_email,
              to_name: invitee_name
            }
          }
        }
      )
      assert_status(201)

      process_events

      assert_equal Roost.mailer.deliveries.length, 1
      assert_includes(invitation_email.to, invitee_email)
      # Test against the raw header, because .from has the normalised version
      # and we want to check the full name
      assert_includes(
        invitation_email.header[:from].value,
        "#{workflow.member_name} <#{workflow.member_email}>"
      )
      assert_match(
        /Harry Potter invited you to join Roost/,
        invitation_email.subject
      )
    end
  end

  private

  def invitation_email
    Roost.mailer.deliveries.last
  end

  def process_events
    events.each do |event|
      esps.each { |ep| ep.process(event) }
    end
  end

  def events
    Roost.event_store.get_next_from(0, event_types: ['member_invited'])
  end

  def esps
    @esps ||= [Reactors::InvitationMailer.new]
  end
end
