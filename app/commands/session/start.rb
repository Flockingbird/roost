# frozen_string_literal: true

require 'app/aggregates/session'
require 'bcrypt'

module Commands
  module Session
    # Starting a session, AKA "logging in"
    module Start
      ##
      # Command to start a session.
      # TODO: a command is overkill, unless we want to handle logins
      # with e.g. a rate limiter, or notification mail or so.
      class Command < ApplicationCommand
        include BCrypt
        DEFAULT_PARAMS = { 'handle' => '', 'password' => '' }.freeze

        def initialize(params, projection: Projections::Members::Query)
          @payload = DEFAULT_PARAMS.merge(params).slice(*DEFAULT_PARAMS.keys)
          @aggregate_id = aggregate_id

          @projection = projection
        end

        def validate
          return if (pw = member[:password]) &&
                    (Password.new(pw) == payload['password'])

          raise_bad_request(
            'Could not log in. Is the username and password correct?'
          )
        end

        def aggregate_id
          @aggregate_id ||= uuid_v5
        end

        def payload
          super.merge('member_id' => member[:member_id])
        end

        private

        attr_reader :projection

        def aggregate_id_name
          @payload['handle']
        end

        def aggregate_id_namespace
          UUIDGen::NS_USERNAME
        end

        def member
          @member ||= projection.find_by(handle: @payload['handle']) || {}
        end
      end

      ##
      # Handlels the Session::Start::Command
      class CommandHandler < ApplicationCommandHandler
        def aggregate_class
          Aggregates::Session
        end

        def aggregate_method
          :start
        end
      end
    end
  end
end
