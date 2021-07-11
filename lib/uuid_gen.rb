# frozen_string_literal: true

##
# Generates a UUID for a Namespace and an readable identifier
class UUIDGen
  include UUIDTools

  # TODO: replace with HANDLE namespace
  NS_USERNAME = UUID.parse('fb0f6f73-a16d-4032-b508-16519fb4a73a').freeze
  NS_EMAIL    = UUID.parse('2282b78c-85d6-419f-b240-0263d67ee6e6').freeze
  NS_HANDLE   = UUID.parse('7712db07-df77-419a-8c93-2071e8fd2c50').freeze

  def self.uuid(namespace, identifier)
    UUID.sha1_create(namespace, identifier)
  end
end
