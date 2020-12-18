# frozen_string_literal: true

##
# Main policy to allow determining wether a member may perform an action on
# an Aggregate.
# Called from a Controller to determine authorization for a certain
# command. Called from a View (or controller) to determine toggles for UI
# elements.
ApplicationPolicy = Struct.new(:actor, :aggregate, :command) do
end
