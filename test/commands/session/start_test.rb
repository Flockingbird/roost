# frozen_string_literal: true

require 'test_helper'

class SessionStartCommandTest < Minitest::Spec
  subject { Commands::Session::Start::Command.new(params) }

  describe 'with username' do
    let(:params) { { 'username' => 'hpotter' } }
    let(:uuid_v5_for_username) { '404fd9f9-c5fc-5b21-b2a9-9ad650520aff' }

    it 'generates a UUIDv5 for this username' do
      assert_equal(uuid_v5_for_username, subject.aggregate_id)
    end
  end

  describe 'without username' do
    let(:params) { { 'username' => '' } }

    it 'handles empty username' do
      assert_equal(subject.aggregate_id, '')
    end
  end
end
