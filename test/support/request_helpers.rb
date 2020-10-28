# frozen_string_literal: true

require 'ostruct'
require 'json'
require 'rack/test'

module RequestHelpers
  include Rack::Test::Methods

  def app
    raise NotImplementedError
  end

  def id_from_header
    matches = last_response.headers['Location'].match(%r{.*/([^/]*)$})
    matches[1] if matches
  end

  def put_json(url, body, env = {})
    put(url, body.to_json, env)
  end

  def post_json(url, body = {}, env = {})
    post(url, body.to_json, env)
  end

  def assert_status(status, message = nil)
    message ||= "Expected #{status}, got #{last_response.status}.\n"\
                "#{last_response.body}"
    assert_equal(status, last_response.status, message)
  end

  def parsed_response
    JSON.parse(last_response.body, symbolize_names: true)
  end

  def authentication_payload
    return @authentication_payload if @authentication_payload

    now = Time.now.to_i

    @authentication_payload = {
      exp: now + 4 * 3600,
      nbf: now - 3600,
      iat: now,
      aud: 'audience',
      jti: jti_digest,
      # TODO: we'll need to add more than just a claim 'I am this person'; a
      # token or other authentication header
      sub: workflow.aggregate_id
    }
  end

  def jwt
    Rack::JWT::Token
  end

  def secret
    ENV['JWT_SECRET']
  end

  private

  def jti_digest
    Digest::MD5.hexdigest([secret, Time.now.to_i].join(':').to_s)
  end
end
