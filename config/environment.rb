# frozen_string_literal: true

require 'mail'
require 'event_sourcery'
require 'event_sourcery/postgres'

Dir.glob("#{__dir__}/../app/events/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/../app/reactors/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/../app/projections/**/projector.rb").sort.each do |f|
  require f
end

##
# The main app, integrated under Roost
class Roost
  ##
  # Holds the configuration for Roost. Mainly event-sourcery config.
  class Config
    attr_accessor :database_url
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  def self.production?
    environment == 'production'
  end

  def self.development?
    environment == 'development'
  end

  def self.environment
    ENV.fetch('APP_ENV', 'development')
  end

  def self.mailer
    return @mailer if @mailer

    Mail.defaults do
      delivery_method(:test)
    end
    @mailer = Mail::TestMailer
  end

  def self.event_store
    EventSourcery::Postgres.config.event_store
  end

  def self.event_source
    EventSourcery::Postgres.config.event_store
  end

  def self.tracker
    EventSourcery::Postgres.config.event_tracker
  end

  def self.event_sink
    EventSourcery::Postgres.config.event_sink
  end

  def self.projections_database
    EventSourcery::Postgres.config.projections_database
  end

  def self.repository
    @repository ||= EventSourcery::Repository.new(
      event_source: event_source,
      event_sink: event_sink
    )
  end

  def self.base_path
    Pathname.new(File.join(__dir__, '..'))
  end
end

unless Roost.production?
  require 'dotenv'
  Dotenv.load(Roost.base_path.join(".env.#{ENV['APP_ENV']}"),
              Roost.base_path.join('.env'))
end

Roost.configure do |config|
  config.database_url = ENV['DATABASE_URL']
end
