# frozen_string_literal: true

require 'test_helper'
require 'sinatra'
require 'bcrypt'

class NewRegistrationCommandTest < Minitest::Spec
  let(:subject_class) { Commands::Registration::NewRegistration::Command }
  subject { subject_class.new(params) }

  describe 'with email' do
    let(:params) do
      Sinatra::IndifferentHash.new.merge(email: 'harry@example.com')
    end

    let(:uuid_v5_for_email) { '377fc540-ff6b-5ddc-9ad8-1d9e9917f626' }

    it 'generates a UUIDv5 for this email' do
      assert_equal(uuid_v5_for_email, subject.aggregate_id)
    end
  end

  describe 'without email' do
    let(:params) do
      Sinatra::IndifferentHash.new.merge(email: '')
    end

    it 'has no aggregate_id' do
      assert_equal(subject.aggregate_id, '')
    end
  end

  describe 'password' do
    let(:password) { 'caput draconis' }
    subject do
      params = Sinatra::IndifferentHash.new.merge(password: password)
      subject_class.new(params)
    end

    it 'generates a secure hash of the password' do
      assert_equal(
        BCrypt::Password.new(subject.payload['password']),
        password
      )
    end
  end

  describe 'validate' do
    let(:valid_params) do
      Sinatra::IndifferentHash.new.merge(
        email: 'harry@example.com',
        handle: Handle.new('hpotter').to_s,
        password: 'caput draconis'
      )
    end

    it 'raises BadRequest when email is empty' do
      assert_raises(BadRequest, 'email is blank') do
        subject_class.new(valid_params.merge(email: '')).validate
      end
    end

    it 'raises BadRequest when email is nil' do
      assert_raises(BadRequest, 'email is blank') do
        subject_class.new(valid_params.merge(email: nil)).validate
      end
    end

    it 'raises BadRequest when username is empty' do
      assert_raises(BadRequest, 'handle is blank') do
        subject_class.new(valid_params.merge(handle: '')).validate
      end
    end

    it 'raises BadRequest when password is empty' do
      assert_raises(BadRequest, 'password is blank') do
        subject_class.new(valid_params.merge(password: '')).validate
      end
    end
  end
end
