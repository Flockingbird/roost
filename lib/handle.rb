# frozen_string_literal: true

##
# Handles the Handles (hehehe).
# Parses and formats consistently @harry@example.org alike handles over domains
# and into usenames and domains
class Handle
  attr_reader :username

  def initialize(username, uri = Roost.config.web_url)
    @uri = uri
    @username = username
  end

  def self.parse(handle)
    uri = URI.parse("http://#{handle.gsub(/^@/, '')}")
    new(uri.user, URI::HTTP.build(host: uri.host).to_s)
  end

  def domain
    URI.parse(@uri).host
  end

  def to_s
    "@#{username}@#{domain}"
  end
end
