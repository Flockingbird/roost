# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if Roost.development?

##
# Main fallback controller for all http requests
class ApplicationController < Sinatra::Base
  # Ensure our error handlers are triggered in development
  set :show_exceptions, :after_handler if Roost.development?

  set :views, Roost.root.join('app/web/views')
  set :public_folder, Roost.root.join('app/web/public')

  configure :development do
    # :nocov:
    # This is only enabled in development env, and not test.
    register Sinatra::Reloader
    # :nocov:
  end

  helpers do
    def domain
      Roost.config.domain
    end
  end

  protected

  def requires_authorization
    authorize { current_member.active? }
  end

  def authorize(&block)
    raise Unauthorized unless block.call
  end

  def authorized?
    current_member.active?
  end

  def current_member
    return OpenStruct.new(active?: false) unless member_id

    @current_member ||= Roost.repository.load(Aggregates::Member, member_id)
  end
end
