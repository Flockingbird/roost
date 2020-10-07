# frozen_string_literal: true

require 'minitest/autorun'
require 'database_cleaner'

require 'awesome_print'
require 'byebug'
require 'ostruct'

ENV['APP_ENV'] = ENV['RACK_ENV'] = 'test'
$LOAD_PATH << '.'

require 'config/environment'
require 'app/web/server'

require_relative 'support/data_helpers'
require_relative 'support/event_helpers'
require_relative 'support/file_helpers'
require_relative 'support/location_helpers'
require_relative 'support/request_helpers'
require_relative 'support/time_helpers'
require_relative 'support/web_test_helpers'

Minitest::Test.make_my_diffs_pretty!

module Minitest
  class Spec
    include EventHelpers
    include DataHelpers
    include FileHelpers
    include LocationHelpers
    include RequestHelpers
    include TimeHelpers

    EventSourcery.configure do |config|
      config.logger = Logger.new(nil)
    end

    DatabaseCleaner.strategy = :truncation,
                               { except: %w[spatial_ref_sys query_addresses] }

    VCR.configure do |config|
      config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
      config.hook_into :faraday
    end

    before :each do
      DatabaseCleaner.start
    end
    after :each do
      DatabaseCleaner.clean
    end
  end
end
