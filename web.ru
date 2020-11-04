# frozen_string_literal: true

$LOAD_PATH << '.'

require 'config/environment'
require 'app/web/web_server'

run WebServer.new
