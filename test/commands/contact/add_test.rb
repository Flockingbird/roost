# frozen_string_literal: true

require 'test_helper'
require 'bcrypt'

##
# Test the Commands::Contact::Add::Command
class ContactAddCommandTest < Minitest::Spec
  let(:subject_class) { Commands::Contact::Add::Command }
  subject { subject_class.new(params) }
  let(:params) do
    {
      'handle' => '@harry@example.com',
      'owner_id' => fake_uuid(Aggregates::Contact, 1)
    }
  end

  describe 'with owner_id and handle' do
    let(:uuid_v5_for_contact) { 'aea867c4-c623-5f5c-b6df-f25423d10ab9' }

    it 'generates a UUIDv5 for this combination' do
      assert_equal(uuid_v5_for_contact, subject.aggregate_id)
    end
  end

  describe 'validate' do
    it 'raises BadRequest when handle is empty' do
      assert_raises(BadRequest, 'contact handle is blank') do
        subject_class.new(params.merge('handle' => '')).validate
      end
    end

    it 'raises BadRequest when email is empty' do
      assert_raises(BadRequest, 'owner_id is blank') do
        subject_class.new(params.merge('owner_id' => '')).validate
      end
    end
  end
end
