# frozen_string_literal: true

$LOAD_PATH << '.'

require 'config/environment'
require 'config/database'
require 'app/web/web_server'

run WebServer.new
