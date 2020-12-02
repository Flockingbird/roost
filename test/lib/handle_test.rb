# frozen_string_literal: true

require 'test_helper'

class HandleTest < Minitest::Spec
  it 'parses @ron@example.org handles and strips the @' do
    assert_equal(Handle.parse('@ron@example.org').username, 'ron')
  end

  it 'parses ron@example.org handles' do
    assert_equal(Handle.parse('@ron@example.org').username, 'ron')
  end

  it 'parses ron@any.example.org handles' do
    assert_equal(Handle.parse('@ron@any.example.org').domain, 'any.example.org')
  end

  it 'builds a handle as string from a username using local web_url' do
    assert_equal(Handle.new('harry').to_s, '@harry@example.com')
  end
end
