# frozen_string_literal: true

##
# Policy for the Contact Aggregate
class ContactPolicy < ApplicationPolicy
  def add?
    !anon? && !self?
  end

  private

  def anon?
    actor.null?
  end

  def self?
    actor == aggregate
  end
end
