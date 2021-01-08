# frozen_string_literal: true

require 'test_helper'

##
# Test the Handle library
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

  it 'is equal when both url and username are equal' do
    assert_equal(Handle.new('harry'), Handle.new('harry'))
    assert_equal(
      Handle.new('harry', 'example.com'),
      Handle.new('harry', 'example.com')
    )

    refute_equal(Handle.new('harry'), Handle.new('ron'))
    refute_equal(
      Handle.new('harry', 'example.org'),
      Handle.new('harry', 'example.com')
    )
  end
end
