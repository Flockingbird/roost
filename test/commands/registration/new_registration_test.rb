# frozen_string_literal: true

require 'test_helper'

class NewRegistrationCommandTest < Minitest::Spec
  subject { Commands::Registration::NewRegistration::Command.new(params) }
  describe 'with email' do
    let(:params) { { email: 'harry@example.com' } }
    let(:uuid_v5_for_email) { '2f4e9c9c-6280-56e7-9542-f6dfa52171ea' }

    it 'generates a UUIDv5 for this email' do
      assert_equal(subject.aggregate_id, uuid_v5_for_email)
    end
  end
end
