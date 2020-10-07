require 'event_sourcery'
require 'event_sourcery/postgres'

Dir.glob(__dir__ + '/../app/events/*.rb').each { |f| require f }
Dir.glob(__dir__ + '/../app/reactors/*.rb').each { |f| require f }
Dir.glob(__dir__ + '/../app/projections/**/projector.rb').each { |f| require f }

module Roost
  class Config
    attr_accessor :database_url
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  def self.environment
    ENV.fetch('RACK_ENV', 'development')
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
end

Roost.configure do |config|
  config.database_url = ENV['DATABASE_URL'] || "postgres://127.0.0.1:5432/roost_#{Roost.environment}"
end

EventSourcery::Postgres.configure do |config|
  database = Sequel.connect(Roost.config.database_url)

  # NOTE: Often we choose to split our events and projections into separate
  # databases. For the purposes of this example we'll use one.
  config.event_store_database = database
  config.projections_database = database
end
