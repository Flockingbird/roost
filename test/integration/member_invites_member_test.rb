# frozen_string_literal: true

require 'test_helper'
require 'support/workflows/add_member'

describe 'member invites member' do
  describe 'POST /invitations' do
    let(:workflow) { Workflows::AddMember.new(self) }
    let(:invitee_email) { 'irene@example.com' }
    let(:invitee_name) { 'Irene' }

    before do
      workflow.call
      header('Content-Type', 'application/vnd.api+json')
      header('Accept', 'application/vnd.api+json')

      bearer_token = jwt.encode(authentication_payload, secret, 'HS256')
      header('Authorization', "Bearer #{bearer_token}")
    end

    it 'sends an invitation email' do
      skip 'Implement mailer'
      mailer = Roost.config.mailer
      assert_equal mailer.sent.length, 0
      post_json(
        '/invitations',
        {
          data: {
            type: 'invitation',
            attributes: {
              to_email: invitee_email,
              to_name: invitee_name
            }
          }
        }.to_json
      )
      assert_status(200)
      assert_match(%r{http://example\.org/invitations/(.*)},
                   last_response.headers['Location'])

      invitation_email = mailer.sent.last
      assert_equal?(invitation_email.to,
                    "\"#{invitee_name}\" <#{invitee_email}>")
      assert_equal(invitee_email.from,
                   "\"#{invitee_name}\" <#{invitee_email}>")
    end
  end
end
