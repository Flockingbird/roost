ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'securerandom'
require 'database_cleaner'

$LOAD_PATH << '.'

require 'config/environment'
require 'app/web/server'
require 'spec/support/request_helpers'

RSpec.configure do |config|
  config.include(Rack::Test::Methods, type: :request)
  config.include(RequestHelpers, type: :request)

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed

  EventSourcery.configure do |config|
    config.logger = Logger.new(nil)
  end

  config.before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
end
