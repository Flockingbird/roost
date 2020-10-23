# frozen_string_literal: true

module Commands
  ##
  # Main ApplicationCommandHandler; runs the command, to be inherited from
  # and extended when commands needs specific handling.
  class ApplicationCommandHandler
    def initialize(repository: Roost.repository)
      @repository = repository
    end
  end
end
