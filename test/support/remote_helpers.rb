# frozen_string_literal: true

##
# Helpers for testing events.
module RemoteHelpers
  def at(instance, &block)
    web_url_was = config.web_url
    domain_was = config.domain
    fqdn = instance.fqdn

    move_to_instance(URI::HTTP.build(host: fqdn, path: '').to_s, fqdn)
    Capybara.using_session("on #{fqdn}") { instance.instance_eval(&block) }
  ensure
    move_to_instance(web_url_was, domain_was)
  end

  private

  def move_to_instance(web_url, domain)
    config.web_url = web_url
    config.domain = domain
  end

  def config
    Roost.config
  end

  # Test standin for a server, instance, that is external.
  class RemoteInstance < SimpleDelegator
    attr_reader :fqdn

    def initialize(fqdn, test_context)
      @fqdn = fqdn
      super(test_context)
    end
  end
end
