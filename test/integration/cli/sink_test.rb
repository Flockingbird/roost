# frozen_string_literal: true

require 'test_helper'
require 'open3'

##
# As a owner of an instance
# When I bootstrap my instance
# Then I want to import exiting data
# So that I have data in my instance
class SinkTest < Minitest::Spec
  let(:input_file) { fixtures('input/harry_potter.json') }

  it 'creates an event' do
    run_sink_pipe
    assert_kind_of(MemberAdded, last_event)
    refute_nil(last_event.aggregate_id)
    assert_equal(last_event.body['name'], 'Harry Potter')
  end

  it 'updates duplicates and continues' do
    run_sink_pipe
    run_sink_pipe
  end

  def run_sink_pipe
    status_list = Open3.pipeline(
      ['cat', input_file],
      [{ 'LOG_LEVEL' => '1' }, './bin/sink']
    )
    status_list.each { |status| assert status.success? }
  end
end
