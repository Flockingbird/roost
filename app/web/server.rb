# frozen_string_literal: true

require 'sinatra'
Dir.glob("#{__dir__}/../projections/**/query.rb").sort.each { |f| require f }

##
# The Common Server. Shared configuration and setup between API, Web etc.
class Server < Sinatra::Base
  BadRequest = Class.new(StandardError)
  UnprocessableEntity = Class.new(StandardError)

  # Ensure our error handlers are triggered in development
  set :show_exceptions, :after_handler if Roost.development?

  configure :development do
    require 'better_errors'
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  def current_member
    @current_member ||= Projections::Members::Query.find(
      request.env['jwt.payload']['sub']
    )
  end
end
