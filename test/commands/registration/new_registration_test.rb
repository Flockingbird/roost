# frozen_string_literal: true

require 'test_helper'

class NewRegistrationCommandTest < Minitest::Spec
  subject { Commands::Registration::NewRegistration::Command.new(params) }
  describe 'with email' do
    let(:params) { { 'email' => 'harry@example.com' } }
    let(:uuid_v5_for_email) { '377fc540-ff6b-5ddc-9ad8-1d9e9917f626' }

    it 'generates a UUIDv5 for this email' do
      assert_equal(uuid_v5_for_email, subject.aggregate_id)
    end
  end

  describe 'without email' do
    let(:params) { { 'email' => '' } }

    it 'has no aggregate_id' do
      assert_equal(subject.aggregate_id, '')
    end
  end
end
