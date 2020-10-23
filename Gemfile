# frozen_string_literal: true

source 'https://rubygems.org'

gem 'event_sourcery', git: 'https://github.com/envato/event_sourcery.git'
gem 'event_sourcery-postgres', git: 'https://github.com/envato/event_sourcery-postgres.git'

gem 'mail'
gem 'rack-jwt'
gem 'rake'
gem 'sinatra'
# NOTE: pg is an implicit dependency of event_sourcery-postgres but we need to
# lock to an older version for deprecation warnings.
gem 'pg', '0.20.0'

group :development, :test do
  gem 'awesome_print'
  gem 'better_errors'
  gem 'byebug'
  gem 'database_cleaner-sequel'
  gem 'dotenv', '~> 2.7'
  gem 'event_sourcery_generators', git: 'https://github.com/envato/event_sourcery_generators.git'
  gem 'minitest'
  gem 'pry'
  gem 'rack-test'
  gem 'rspec'
  gem 'rubocop', '~> 0.82.0' # Matches superlinter version
  gem 'shotgun'

  # Bug in later versions: https://github.com/codeclimate/test-reporter/issues/413
  gem 'simplecov', '~> 0.17.0'
end
