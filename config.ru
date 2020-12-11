# frozen_string_literal: true

$LOAD_PATH << '.'

require 'sinatra/base'

require 'config/environment'
require 'config/database'
require 'app/web/server'

map('/') { run Web::HomeController }
map('/m') { run Web::ProfilesController }

map('/login') { run Web::LoginController }
# TODO: change from RPC alike "register" to "registration"
map('/register') { run Web::RegistrationsController }
map('/confirmation') { run Web::ConfirmationsController }
map('/profile') { run Web::MyProfilesController }
map('/contacts') { run Web::ContactsController }
map('/updates') { run Web::UpdatesController }

# API endpoints for now all live in one controller
# TODO: split out by features
map('/api') { run Api::ApiController }
