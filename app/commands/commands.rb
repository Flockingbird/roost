# frozen_string_literal: true

##
# Commands namespace
# Has some factory methods for commands
module Commands
  ##
  # Helper to run the common pattern of one handler per command, in the
  # same namespace.
  def self.handle(root, name, params)
    command = Object.const_get("Commands::#{root}::#{name}::Command")
                    .new(params)
    Object.const_get("Commands::#{root}::#{name}::CommandHandler")
          .new(command: command).handle
  end
end
