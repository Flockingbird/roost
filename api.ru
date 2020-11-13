# frozen_string_literal: true

$LOAD_PATH << '.'

require 'config/environment'
require 'config/database'
require 'app/web/api_server'

run ApiServer.new
