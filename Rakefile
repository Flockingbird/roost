$LOAD_PATH.unshift '.'

task :environment do
  require 'config/environment'
end

desc 'Run Event Stream Processors'
task run_processors: :environment do
  puts 'Starting Event Stream processors'

  event_source = Roost.event_source
  tracker = Roost.tracker
  db_connection = Roost.projections_database

  # Need to disconnect before starting the processors
  # to ensure each forked process has its own connection
  db_connection.disconnect

  # Show our ESP logs in foreman immediately
  $stdout.sync = true

  processors = [
    # Add your processors here, like so:
    #
    # EventSourceryTodoApp::Projections::CompletedTodos::Projector.new(
    #   tracker: tracker,
    #   db_connection: db_connection,
    # ),
  ]

  EventSourcery::EventProcessing::ESPRunner.new(
    event_processors: processors,
    event_source: event_source,
  ).start!
end

namespace :db do
  desc 'Create database'
  task create: :environment do
    url = Roost.config.database_url
    database_name = File.basename(url)
    database = Sequel.connect URI.join(url, '/template1').to_s
    begin
      database.run("CREATE DATABASE #{database_name}")
    rescue StandardError => e
      puts "Could not create database '#{database_name}': #{e.class.name} #{e.message}"
    end
    database.disconnect
  end

  desc 'Drop database'
  task drop: :environment do
    url = Roost.config.database_url
    database_name = File.basename(url)
    database = Sequel.connect URI.join(url, '/template1').to_s
    database.run("DROP DATABASE IF EXISTS #{database_name}")
    database.disconnect
  end

  desc 'Migrate database'
  task migrate: :environment do
    database = EventSourcery::Postgres.config.event_store_database
    begin
      EventSourcery::Postgres::Schema.create_event_store(db: database)
    rescue StandardError => e
      puts "Could not create event store: #{e.class.name} #{e.message}"
    end
  end
end
