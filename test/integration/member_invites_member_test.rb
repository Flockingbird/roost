# frozen_string_literal: true

require 'test_helper'
require 'support/workflows/add_member'

class MemberInvitesMemberTest < Minitest::ApiSpec
  describe 'POST /invitations' do
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
        "/invitations/#{fake_uuid(Aggregates::Member, 1)}",
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

      process_events(['member_invited'])

      assert_equal Roost.mailer.deliveries.length, 1
      assert_includes(invitation_email.to, invitee_email)
      # Test against the raw header, because .from has the normalised version
      # and we want to check the full name
      assert_includes(
        invitation_email.header[:from].value,
        "#{workflow.member_name} <#{workflow.member_email}>"
      )
      assert_match(
        /Harry Potter invited you to join Flockingbird/,
        invitation_email.subject
      )
    end
  end

  private

  def invitation_email
    Roost.mailer.deliveries.last
  end
end
