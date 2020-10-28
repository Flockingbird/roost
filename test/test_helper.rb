# frozen_string_literal: true

require 'minitest/autorun'
require 'database_cleaner'

require 'awesome_print'
require 'byebug'
require 'ostruct'

require 'simplecov'
SimpleCov.start

ENV['APP_ENV'] = ENV['RACK_ENV'] = 'test'
$LOAD_PATH << '.'

require 'config/environment'
require 'config/database'
require 'app/web/api_server'
require 'app/web/web_server'

require_relative 'support/data_helpers'
require_relative 'support/event_helpers'
require_relative 'support/file_helpers'
require_relative 'support/request_helpers'
require_relative 'support/time_helpers'

Minitest::Test.make_my_diffs_pretty!

module Minitest
  class Spec
    include DataHelpers
    include EventHelpers
    include FileHelpers
    include RequestHelpers
    include TimeHelpers

    EventSourcery.configure do |config|
      config.logger = Logger.new(nil)
    end

    DatabaseCleaner[:sequel, connection: Roost.event_store]
    DatabaseCleaner[:sequel, connection: Roost.projections_database]
    DatabaseCleaner[:sequel].strategy = :truncation

    before :each do
      DatabaseCleaner[:sequel].start
    end
    after :each do
      DatabaseCleaner[:sequel].clean
    end
  end
end
