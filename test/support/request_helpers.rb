# frozen_string_literal: true

require 'ostruct'
require 'json'
require 'rack/test'

module RequestHelpers
  include Rack::Test::Methods

  def app
    Roost::Server.new
  end

  def id_from_header
    matches = last_response.headers['Location'].match(%r{.*/([^/]*)$})
    matches[1] if matches
  end

  def put_json(url, body, headers = {})
    defaults = { 'Content-Type' => 'application/vnd.api+json' }
    put url, body.to_json, headers.merge(defaults)
  end

  def assert_status(status, message = nil)
    message ||= "Expected #{status}, got #{last_response.status}.\n"\
                "#{last_response.body}"
    assert_equal(status, last_response.status, message)
  end
end
