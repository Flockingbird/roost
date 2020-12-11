# frozen_string_literal: true

module Web
  ##
  # Renders homepage.
  # Also acts as fallback for static files
  class HomeController < WebController
    get('/') { erb :home }
  end
end
