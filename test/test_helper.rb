# frozen_string_literal: true

require 'database_cleaner'

require 'awesome_print'
require 'byebug'
require 'capybara/minitest'
require 'ostruct'

require_relative 'support/data_helpers'
require_relative 'support/event_helpers'
require_relative 'support/file_helpers'
require_relative 'support/mail_helpers'
require_relative 'support/request_helpers'
require_relative 'support/time_helpers'
require_relative 'support/workflows/base'

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

ENV['APP_ENV'] = ENV['RACK_ENV'] = 'test'
$LOAD_PATH << '.'

require 'config/environment'
require 'config/database'
require 'app/web/api_server'
require 'app/web/web_server'

Minitest::Test.make_my_diffs_pretty!

module Minitest
  class Spec
    include DataHelpers
    include EventHelpers
    include FileHelpers
    include MailHelpers
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
      setup_processors
      Roost.mailer.deliveries.clear
    end

    after :each do
      DatabaseCleaner[:sequel].clean
    end
  end

  class WebSpec < Spec
    include Capybara::DSL
    include Capybara::Minitest::Assertions

    def app
      WebServer.new
    end

    def setup
      Capybara.app = app
      Capybara.default_driver = :rack_test
      super
    end

    def teardown
      Capybara.reset_sessions!
      Capybara.use_default_driver
      super
    end
  end

  class ApiSpec < Spec
    def app
      ApiServer.new
    end
  end
end
