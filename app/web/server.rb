# frozen_string_literal: true

require 'sinatra/reloader' if Roost.development?

Dir.glob("#{__dir__}/../projections/**/query.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/../commands/**/*.rb").sort.each { |f| require f }
Dir.glob("#{__dir__}/view_models/*.rb").sort.each { |f| require f }

require_relative 'controllers/application_controller'
require_relative 'controllers/web/web_controller'
require_relative 'controllers/api/api_controller'

Dir.glob("#{__dir__}/controllers/**/*controller.rb").sort.each { |f| require f }
