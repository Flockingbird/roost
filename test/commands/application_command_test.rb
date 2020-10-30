# frozen_string_literal: true

require 'test_helper'

class ApplicatCommandTest < Minitest::Spec
  describe 'with aggregate_id' do
    let(:params) { { aggregate_id: SecureRandom.uuid } }

    it 'is valid' do
      assert(subject.validate)
    end
  end

  describe 'without aggregate_id' do
  end

  private

  def subject
    @subject ||= Commands::ApplicationCommand.new(params)
  end
end
