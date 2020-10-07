$LOAD_PATH << '.'

require 'config/environment'
require 'app/web/server'

run Roost::Server.new
