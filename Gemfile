source 'https://rubygems.org'

gem 'event_sourcery', git: 'https://github.com/envato/event_sourcery.git'
gem 'event_sourcery-postgres', git: 'https://github.com/envato/event_sourcery-postgres.git'

gem 'rake'
gem 'sinatra'
# NOTE: pg is an implicit dependency of event_sourcery-postgres but we need to
# lock to an older version for deprecation warnings.
gem 'pg', '0.20.0'

group :development, :test do
  gem 'pry'
  gem 'rspec'
  gem 'rack-test'
  gem 'database_cleaner'
  gem 'better_errors'
  gem 'shotgun'
end
