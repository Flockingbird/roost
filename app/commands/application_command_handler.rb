# frozen_string_literal: true

module Commands
  ##
  # Main ApplicationCommandHandler; runs the command, to be inherited from
  # and extended when commands needs specific handling.
  class ApplicationCommandHandler
    def initialize(repository: Roost.repository)
      @repository = repository
    end

    def handle(command)
      command.validate

      applied_aggregate = apply(
        aggregate(command.aggregate_id),
        command.payload
      )
      repository.save(applied_aggregate)
    end

    protected

    attr_reader :repository
  end
end
