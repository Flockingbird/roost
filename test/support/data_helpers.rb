# frozen_string_literal: true

##
# Helpers for test-data
module DataHelpers
  protected

  def fixtures(file)
    Hours.base_path.join('test', 'fixtures', file).to_s
  end

  def json_fixtures(file)
    JSON.parse(File.read(fixtures(file)), symbolize_names: true)
  end
end
