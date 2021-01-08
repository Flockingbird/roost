# frozen_string_literal: true

require_relative 'workflows/base'

Dir["#{__dir__}/workflows/*.rb"].sort.each { |file| require file }

##
# Workflows are classes that walk us through steps using the official interface.
module Workflows
  def adds_contact(form_attributes = {})
    factory(AddsContact, form_attributes)
  end

  def manage_profile(form_attributes = {})
    factory(ManageProfile, form_attributes)
  end

  def member_logs_in(form_attributes = {})
    factory(MemberLogsIn, form_attributes)
  end

  def member_registers(form_attributes = {})
    factory(MemberRegisters, form_attributes)
  end

  def tags_member(form_attributes = {})
    factory(TagsMember, form_attributes)
  end

  def discover_member(form_attributes = {})
    factory(DiscoversMember, form_attributes)
  end

  # login helper
  def as(login_attributes)
    member_logs_in(login_attributes).upto(:logged_in)
    yield if block_given?
  end

  private

  def factory(klass, form_attributes)
    klass.new(self, form_attributes)
  end
end
