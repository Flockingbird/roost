# frozen_string_literal: true

require 'test_helper'

##
# As a client using the API
# When my session was ended
# Then I want to log in on behalf of a member
# So that I can authenticate and act as a member
class MemberAuthenticatesTest < Minitest::ApiSpec
  describe 'GET /session' do
    let(:workflow) { Workflows::AddMember.new(self) }
    # Override the secret so we can check that it is integrated properly. e.g.
    # avoid testing nil=nil as secret.
    def secret
      's3cr37'
    end

    before do
      workflow.call
    end

    # TODO: we will need to move to OAUTH2 to make this work safely in practice.
    # but, for the PoC, the naive token implementation works. THIS IS INSECURE.
    describe 'with valid token' do
      it 'shows my current session details' do
        token = jwt.encode(authentication_payload, secret, 'HS256')
        header 'Authorization', "Bearer #{token}"
        get '/api/session'
        assert_status(200)
        assert_equal(
          {
            aggregate_id: workflow.aggregate_id,
            name: workflow.member_name,
            email: workflow.member_email,
            handle: ''
          },
          parsed_response
        )
      end
    end

    describe 'with invalid aggregate_id in token' do
      it 'returns an empty member body' do
        authentication_payload[:sub] = fake_uuid(Aggregates::Member, 1)
        token = jwt.encode(authentication_payload, secret, 'HS256')
        header 'Authorization', "Bearer #{token}"
        get '/api/session'
        assert_status(200)
        assert_equal(
          parsed_response,
          { aggregate_id: fake_uuid(Aggregates::Member, 1) }
        )
      end
    end

    describe 'with invalid token' do
      it 'gives access denied' do
        token = jwt.encode(authentication_payload, 'WRONG', 'HS256')
        header 'Authorization', "Bearer #{token}"
        get '/api/session'
        assert_status(401)
      end
    end

    describe 'without token' do
      it 'gives access denied' do
        header 'Authorization', nil
        get '/api/session'
        assert_status(401)
      end
    end
  end
end
