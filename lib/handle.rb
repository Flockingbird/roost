# frozen_string_literal: true

##
# Handles the Handles (hehehe).
# Parses and formats consistently @harry@example.org alike handles over domains
# and into usenames and domains
class Handle
  attr_reader :username, :domain

  def initialize(username,
                 handle_domain = Roost.config.domain,
                 local_domain = Roost.config.domain)
    @domain = handle_domain
    @local_domain = local_domain
    @username = username
  end

  def self.parse(handle)
    uri = URI.parse("http://#{handle.gsub(/^@/, '')}")
    new(uri.user, uri.host)
  end

  def to_s
    return '' if username.to_s.empty?

    "@#{username}@#{domain}"
  end

  def local?
    domain == @local_domain
  end

  def ==(other)
    username == other.username && domain == other.domain
  end
end
