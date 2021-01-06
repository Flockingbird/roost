# frozen_string_literal: true

$LOAD_PATH << '.'

require 'sinatra/base'

require 'config/environment'
require 'config/database'
require 'app/web/server'

use Web::HomeController
use Web::ProfilesController
use Web::TagsController

use Web::LoginController
# TODO: change from RPC alike "register" to "registration"
use Web::RegistrationsController
use Web::ConfirmationsController

use Web::MyProfilesController
use Web::ContactsController
use Web::UpdatesController

use Api::ApiController

run ApplicationController
