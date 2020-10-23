# frozen_string_literal: true

require 'test_helper'
require 'support/workflows/add_member'

describe 'member_authenticates' do
  let(:workflow) { Workflows::AddMember.new(self) }
  # Override the secret so we can check that it is integrated properly. e.g.
  # avoid testing nil=nil as secret.
  def secret
    's3cr37'
  end

  before do
    workflow.call
  end

  describe 'GET /session' do
    # TODO: we will need to move to OAUTH2 to make this work safely in practice.
    # but, for the PoC, the naive token implementation works. THIS IS INSECURE.
    describe 'with valid token' do
      it 'shows my current session details' do
        header 'Authorization', "Bearer #{jwt.encode(authentication_payload, secret, 'HS256')}"
        get '/session'
        assert_status(200)
        assert_equal(
          parsed_response,
          {
            member_id: workflow.aggregate_id,
            name: workflow.member_name,
            email: workflow.member_email
          }
        )
      end
    end

    describe 'with invalid aggregate_id in token' do
      it 'returns an empty member body' do
        authentication_payload[:sub] = SecureRandom.uuid
        header 'Authorization', "Bearer #{jwt.encode(authentication_payload, secret, 'HS256')}"
        get '/session'
        assert_status(200)
        assert_equal(parsed_response, {})
      end
    end

    describe 'with invalid token' do
      it 'gives access denied' do
        header 'Authorization', "Bearer #{jwt.encode(authentication_payload, 'WRONG', 'HS256')}"
        get '/session'
        assert_status(401)
      end
    end

    describe 'without token' do
      it 'gives access denied' do
        get '/session'
        assert_status(401)
      end
    end
  end
end
