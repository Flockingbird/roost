CMD_PREFIX=bundle exec
CONTAINER_NAME=roost_development
TEST_FILES_PATTERN ?= **/*_test.rb

# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: all test lint clean setup ruby packages preprocess run

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: test lint
db:
	make _docker-install || make _docker-start
	make _wait
	make _db-setup

# CUSTOM BUILD RULES
test: export APP_ENV=test
test:
	$(CMD_PREFIX) ruby -I lib:test:. -e "Dir.glob('$(TEST_FILES_PATTERN)') { |f| require(f) }"
lint:
	$(CMD_PREFIX) rubocop

clean:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)

run:
	parallel --line-buffer ::: "$(CMD_PREFIX) rackup --port=9292 web.ru" "$(CMD_PREFIX) rackup shotgun --port=9393 api.ru" "$(CMD_PREFIX) rake run_processors"

deploy:
	$(CMD_PREFIX) cap production deploy

_docker-start:
	@if [ -z $(docker ps --no-trunc | grep $(CONTAINER_NAME)) ]; then docker start $(CONTAINER_NAME); fi

_db-setup:
	$(CMD_PREFIX) rake db:create
	$(CMD_PREFIX) rake db:migrate
	$(CMD_PREFIX) rake db:create_projections

_wait:
	sleep 5

##
# Set up the project for building
setup: _ruby _packages _docker-install

_docker-install:
	docker run -p 5432:5432 --name $(CONTAINER_NAME) -e POSTGRES_PASSWORD=$(DB_PASSWORD) -d mdillon/postgis

_ruby:
	bundle install

_packages:
	sudo apt install ruby parallel
