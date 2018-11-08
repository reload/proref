#
# RELOAD MAKE UP
#
# This file exemplifies the commands that should be available in all
# our project repos. The commands may function differently in each project,
# but they should achieve the same goal.
# It should be easy to use these to execute the main day-to-day operations
# required during development.
#
# The commands are:
#   make help
#   make up 
#   make stop
#   make reset
#   make test
#   make logs
#   make status

# =============================================================================
# MAIN COMMAND TARGETS
# =============================================================================

default: help

help: ## Display a list of the public targets
	@grep -F -h "##" $(MAKEFILE_LIST) | grep -v "^_" | grep -F -v fgrep  | sed -e 's/\\$$//' | sed -e 's/##//'

reset: ## Stop all containers, reset their state and start up again.
reset: _reset-container-state up

# Take the whole environment up without altering the existing state of the containers.
up: ## bring up all containers
up: _validate
	docker-compose up -d --remove-orphans

# Stop all containers without altering anything else.
stop: ## stop all containers
	docker-compose stop

# Run tests on a running environment. This target must always be run explicitly.
test: ## run any local tests
test: _ensure-php
	@./scripts/run-tests

# Stream container logs to console.
logs: ## follow docker logs from the containers
	docker-compose logs -f --tail=50

# Show current state of the environment.
status: ## show status of the environment
	docker-compose ps
	docker-compose top

# =============================================================================
# HELPERS
# =============================================================================
# These targets are usually not run manually.

# Check if the environment meets requirements. Requires containers are up.
_validate: _ensure-php
	# Example
	docker-compose exec php drush --version

# Fetch and replace updated containers and db-dump images and run composer install.
_reset-container-state: _docker-pull
	@./scripts/reset-container-state

_ensure-php:
	docker-compose up -d --no-deps php

# Pull all images from Docker Hub.
_docker-pull:
	docker-compose pull --parallel
