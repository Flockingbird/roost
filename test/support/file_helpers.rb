# frozen_string_literal: true

##
# Helpers for testing against files
module FileHelpers
  def assert_file_contains(file, string)
    contents = File.read(file)
    message = %(Expected file "#{file}" to contain "#{string}")
    assert_includes(contents, string, message)
  end
end
