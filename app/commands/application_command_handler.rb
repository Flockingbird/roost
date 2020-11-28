# frozen_string_literal: true

module Commands
  ##
  # Main ApplicationCommandHandler; runs the command, to be inherited from
  # and extended when commands needs specific handling.
  #
  # For now, it always applies the command to an aggregate. But we might want
  # to split it into a AggregateApplyCommandHandler instead.
  class ApplicationCommandHandler
    def initialize(command:, repository: Roost.repository)
      @repository = repository
      @command = command
      @aggregate = nil
    end

    def handle
      command.validate

      applied_aggregate = aggregate.public_send(
        aggregate_method,
        command.payload
      )

      repository.save(applied_aggregate)
      applied_aggregate
    end

    protected

    attr_reader :repository, :command

    def aggregate
      repository.load(aggregate_class, command.aggregate_id)
    end
  end
end
