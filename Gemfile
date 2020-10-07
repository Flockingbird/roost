# frozen_string_literal: true

source 'https://rubygems.org'

gem 'event_sourcery', git: 'https://github.com/envato/event_sourcery.git'
gem 'event_sourcery-postgres', git: 'https://github.com/envato/event_sourcery-postgres.git'

gem 'rake'
gem 'sinatra'
# NOTE: pg is an implicit dependency of event_sourcery-postgres but we need to
# lock to an older version for deprecation warnings.
gem 'pg', '0.20.0'

group :development, :test do
  gem 'better_errors'
  gem 'database_cleaner'
  gem 'pry'
  gem 'rack-test'
  gem 'rspec'
  gem 'rubocop'
  gem 'shotgun'
end
