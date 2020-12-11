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
require_relative 'support/web_test_helpers'
require_relative 'support/workflows'

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

ENV['APP_ENV'] = ENV['RACK_ENV'] = 'test'
$LOAD_PATH << '.'

require 'rack/server'
require 'config/environment'
require 'config/database'

Dir.glob("#{__dir__}/../app/aggregates/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/../app/projections/**/query.rb")
   .sort
   .each { |f| require f }

require_relative '../app/commands/application_command'
require_relative '../app/commands/application_command_handler'
Dir.glob("#{__dir__}/../app/commands/**/*.rb").sort.each { |f| require f }

Minitest::Test.make_my_diffs_pretty!

module Minitest
  class Spec
    include DataHelpers
    include EventHelpers
    include FileHelpers
    include MailHelpers
    include RequestHelpers
    include TimeHelpers
    include Workflows

    EventSourcery.configure do |config|
      config.logger = Logger.new(nil)
    end

    DatabaseCleaner[:sequel, connection: Roost.event_store]
    DatabaseCleaner[:sequel, connection: Roost.projections_database]
    DatabaseCleaner[:sequel].strategy = :truncation

    before :each do
      DatabaseCleaner[:sequel].start
      setup_processors
      deliveries.clear
    end

    after :each do
      DatabaseCleaner[:sequel].clean
    end

    def app
      # Simulate a rackup using the config and routing in config.ru
      Rack::Server.new(config: Roost.root.join('config.ru').to_s).app
    end
  end

  class WebSpec < Spec
    include Capybara::DSL
    include Capybara::Minitest::Assertions
    include WebTestHelpers

    def setup
      Capybara.app = app
      Capybara.default_driver = :rack_test
      Capybara.save_path = Roost.root.join('tmp')
      super
    end

    def teardown
      Capybara.reset_sessions!
      Capybara.use_default_driver
      super
    end
  end

  class ApiSpec < Spec
  end
end
