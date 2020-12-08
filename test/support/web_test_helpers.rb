# frozen_string_literal: true

##
# Helpers to interact with web-pages
module WebTestHelpers
  ##
  # Click on an icon by its description
  def click_icon(descriptor)
    find("span.icon i.mdi-#{descriptor}").find(:xpath, '../..').click
  end

  ##
  # Find the main menu
  def main_menu(identifier)
    find('nav.navbar a', text: identifier)
  end

  ##
  # Find a status message
  def flash(type)
    find(".notification.is-#{type}")
  end
end
