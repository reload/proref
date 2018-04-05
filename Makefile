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
#   make up 	- bring up all containers
#   make stop 	- stop all containers
#   make reset 	- stop all containers, update them and any dbs, and restart
#   make test	- run any local tests
#   make logs   - follow docker logs from the containers
#   make status - show status of the environment

# =============================================================================
# MAIN COMMAND TARGETS
# =============================================================================

# Nuke, update and reinstall everything and bring it all up again.
reset: update up

# Take the whole environment up without altering the existing state of the containers.
up: validate
	docker-compose up -d --remove-orphans

# Stop all containers without altering anything else.
stop:
	docker-compose stop

# Run tests on a running environment. This target must always be run explicitly.
test: ensure-php
	docker-compose exec php /bin/bash -c 'cd .. && ./vendor/bin/phpunit -c ./tests/phpunit.xml.dist'

# Stream container logs to console.
logs:
	docker-compose logs -f --tail=50

# Show current state of the environment.
status:
	docker-compose ps
	docker-compose top


# =============================================================================
# OTHER COMMAND TARGETS
# =============================================================================
# These commands are specific to this project.

# Check if the environment meets requirements. Requires containers are up.
validate: ensure-php
	# Example
	docker-compose exec php drush --version

# Reinstall Drupal if required (normally not).
drupal-reinstall: ensure-php
	docker-compose exec php drush site-install -y minimal --config-dir=../config/sync --account-mail=noreply+proref@reload.dk --account-pass=admin --site-mail=noreply+proref@reload.dk --site-name=ProRef --db-su=root --db-su-pw=root --db-url=mysql://db:db@db/db

# Import the local config into a running Drupal site.
drupal-locale-update: ensure-php
	docker-compose exec php drush -y locale-check
	docker-compose exec php drush -y locale-update

# Run Drupal Console with an arbitrary set of parameters.
# 	Example: make drupal-run CMD=site:status
drupal-run: ensure-php
	docker-compose exec php drupal ${CMD}

# Run Drush with an arbitrary set of parameters.
# 	Example: make drush-run CMD=status
drush-run: ensure-php
	docker-compose exec php drush ${CMD}


# =============================================================================
# HELPERS
# =============================================================================
# These targets are usually not run manually.

# Fetch and replace updated containers and db-dump images and run composer install.
update: docker-pull
	docker-compose rm --stop --force
	docker-compose up -d php
	# wait just a bit before proceeding, since the php container is not ready right away.
	sleep 5s
	docker-compose exec php /bin/bash -c 'cd .. && rm -rf vendor/'
	docker-compose exec php /bin/bash -c 'cd .. && composer --no-interaction install --optimize-autoloader'
	docker-compose exec php drush --version
	#docker-compose exec php drush cache-rebuild
	#docker-compose exec php drush -y updatedb --entity-updates
	#docker-compose exec php drush -y config-import

ensure-php:
	docker-compose up -d --no-deps php

# Pull all images from Docker Hub.
docker-pull:
	docker-compose pull --parallel
