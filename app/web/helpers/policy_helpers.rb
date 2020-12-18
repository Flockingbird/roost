# frozen_string_literal: true

require 'app/web/policies/contact_policy'

##
# Holds the may_x? helpers for views and controllers, that wrap the policies
module PolicyHelpers
  def may_add_contact?
    ContactPolicy.new(current_member, contact).add?
  end
end
