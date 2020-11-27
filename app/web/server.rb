# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if Roost.development?
Dir.glob("#{__dir__}/../projections/**/query.rb").sort.each { |f| require f }

##
# The Common Server. Shared configuration and setup between API, Web etc.
class Server < Sinatra::Base
  # Ensure our error handlers are triggered in development
  set :show_exceptions, :after_handler if Roost.development?

  configure :development do
    # :nocov:
    # This is only enabled in development env, and not test.
    register Sinatra::Reloader
    # :nocov:
  end

  def current_member
    @current_member ||= Projections::Members::Query.find(member_id)
  end

  def aggregate_id
    @aggregate_id ||= SecureRandom.uuid
  end

  protected

  ##
  # Helper to run the common pattern of one handler per command, in the
  # same namespace.
  def handle_command(root, name, params)
    command = Object.const_get("Commands::#{root}::#{name}::Command")
                    .new(params)
    Object.const_get("Commands::#{root}::#{name}::CommandHandler")
          .new(command: command).handle
  end
end
