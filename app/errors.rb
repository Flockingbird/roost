# frozen_string_literal: true

##
# HTTP 400 bad Request
BadRequest = Class.new(StandardError)
##
# HTTP 401 Unauthorized
Unauthorized = Class.new(StandardError)
##
# HTTP 422 bad Request
UnprocessableEntity = Class.new(StandardError)
