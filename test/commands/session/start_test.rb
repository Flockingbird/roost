# frozen_string_literal: true

require 'test_helper'
require 'sinatra'

class SessionStartCommandTest < Minitest::Spec
  let(:projection) { Minitest::Mock.new }
  let(:params) do
    Sinatra::IndifferentHash.new.merge(
      { handle: Handle.new('hpotter').to_s, password: 'caput draconis' }
    )
  end
  let(:member) { nil }

  subject do
    Commands::Session::Start::Command.new(params, projection: projection)
  end

  before do
    projection.expect(:find_by, member, [{ handle: '@hpotter@example.com' }])
  end

  describe 'with username' do
    let(:uuid_v5_for_username) { 'f0f63857-aa2b-5260-ab3d-886116f0f369' }

    it 'generates a UUIDv5 for this username' do
      assert_equal(uuid_v5_for_username, subject.aggregate_id)
    end
  end

  describe 'without username' do
    before { params[:handle] = '' }

    it 'handles empty username' do
      assert_equal(subject.aggregate_id, '')
    end
  end

  describe '#validate' do
    describe 'without member with username' do
      it 'fails if no member with this username is found' do
        assert_raises(BadRequest) { subject.validate }
      end
    end

    describe 'with member with username' do
      let(:member) { { password: BCrypt::Password.create('caput draconis') } }

      it 'passes if credentials match a record' do
        assert_nil(subject.validate)
      end

      it "fails if passwords don't match" do
        params[:password] = 'pure-blood'
        subject = Commands::Session::Start::Command.new(
          params,
          projection: projection
        )
        assert_raises(BadRequest) { subject.validate }
      end
    end
  end

  describe 'payload' do
    let(:member) { { member_id: fake_uuid(Aggregates::Member, 1) } }
    it 'includes member_id' do
      assert_equal(subject.payload['member_id'], member[:member_id])
    end
  end
end
