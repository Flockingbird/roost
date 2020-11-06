# frozen_string_literal: true

##
# Module that has all url builders hardcoded to be included
# in a class that needs access to an URL
module UrlHelpers
  protected

  def confirmation_url(aggregate_id)
    "#{Roost.config.web_url}/confirmation/#{aggregate_id}"
  end
end
