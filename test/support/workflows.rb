# frozen_string_literal: true

require_relative 'workflows/base'

Dir["#{__dir__}/workflows/*.rb"].sort.each { |file| require file }

module Workflows
  def manage_profile(form_attributes = {})
    factory(ManageProfile, form_attributes)
  end

  def member_logs_in(form_attributes = {})
    factory(MemberLogsIn, form_attributes)
  end

  def member_registers(form_attributes = {})
    factory(MemberRegisters, form_attributes)
  end

  private

  def factory(klass, form_attributes)
    klass.new(self, form_attributes)
  end
end
