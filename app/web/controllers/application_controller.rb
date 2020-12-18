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

  protected

  def requires_authorization
    authorize { !current_member.null? }
  end

  def authorize(&block)
    raise Unauthorized unless block.call
  end

  def current_member
    @current_member ||= ViewModels::Profile.new(
      Projections::Members::Query.find(member_id)
    )
  end
end
