# frozen_string_literal: true

$LOAD_PATH.unshift '.'

task :environment do
  require 'config/environment'
end

task :database do
  require 'config/database'
end

desc 'Run Event Stream Processors'
task run_processors: %i[environment database] do
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
    Roost::Projections::Invitations::Projector.new(
      tracker: tracker,
      db_connection: db_connection
    )
  ]

  EventSourcery::EventProcessing::ESPRunner.new(
    event_processors: processors,
    event_source: event_source
  ).start!
end

namespace :db do
  desc 'Create database'
  task create: :environment do
    begin
      database.run("CREATE DATABASE #{database_name}")
    rescue StandardError => e
      puts "Could not create database '#{database_name}': #{e.class.name}"\
           "#{e.message}"
    end
    database.disconnect
  end

  desc 'Drop database'
  task drop: :environment do
    database.run("DROP DATABASE IF EXISTS #{database_name}")
    database.disconnect
  end

  desc 'Migrate database'
  task migrate: %i[environment database] do
    database = EventSourcery::Postgres.config.event_store_database
    begin
      EventSourcery::Postgres::Schema.create_event_store(db: database)
    rescue StandardError => e
      puts "Could not create event store: #{e.class.name} #{e.message}"
    end
  end

  desc 'Setup Event Stream projections'
  task create_projections: %i[environment database] do
    [Roost::Projections::Members::Projector].map(&:new).each(&:setup)
  end

  def database
    Sequel.connect URI.join(url, '/template1').to_s
  end

  def database_name
    File.basename(url)
  end

  def url
    Roost.config.database_url
  end
end
