# frozen_string_literal: true

$LOAD_PATH << '.'

require 'config/environment'
require 'app/web/server'

run Server.new
