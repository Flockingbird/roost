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
        UUID_USERNAME_NAMESPACE = UUIDTools::UUID.parse(
          'fb0f6f73-a16d-4032-b508-16519fb4a73a'
        )
        DEFAULT_PARAMS = { 'username' => '', 'password' => '' }.freeze

        def initialize(params, projection: Projections::Members::Query)
          @payload = DEFAULT_PARAMS.merge(params).slice(*DEFAULT_PARAMS.keys)
          @aggregate_id = aggregate_id

          @projection = projection
        end

        def validate
          return if member && (pw = member[:password]) &&
                    (Password.new(pw) == payload['password'])

          raise_bad_request(
            'Could not log in. Is the username and password correct?'
          )
        end

        def aggregate_id
          @aggregate_id ||= uuid_v5
        end

        private

        attr_reader :projection

        def aggregate_id_name
          payload['username']
        end

        def aggregate_id_namespace
          UUID_USERNAME_NAMESPACE
        end

        def member
          @member ||= projection.find_by(username: payload['username'])
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
