# RELOAD PROJECT MAKE UP
# This file exemplifies the main commands that should be available in all
# our project repos. The commands may function differently in each project,
# but they should achieve the same goal.
#
# The commands are:
#   make reset 	- stop all containers, update them and db dumps and start again
#   make up 	- just bring up all containers
#   make stop 	- stop all containers
#   make test	- run any local tests
#   make logs   - follow docker logs from the containers
#   make status - show status of the environment

# List of containers
DOCKER_CONTAINERS = web fpm db mailhog

# =============================================================================
# MAIN COMMAND TARGETS
# =============================================================================
# These commands affect the application as a whole, across multiple containers
# and subsystems.
# It should be easy to use these to execute the main day-to-day operations
# required during development.

# Nuke, update and reinstall everything and bring it all up again.
reset: update up

# Take the whole environment up without altering the existing state of the containers.
up: validate
	docker-compose up -d --remove-orphans ${DOCKER_CONTAINERS}

# Stop all containers without altering anything else.
stop:
	docker-compose stop ${DOCKER_CONTAINERS}

# Run tests on a running environment. This target must always be run explicitly.
test: ensure-fpm
	docker-compose exec fpm /bin/bash -c 'cd .. && ./vendor/bin/phpunit -c ./tests/phpunit.xml.dist'

# Stream container logs to console.
logs:
	docker-compose logs -f --tail=50 ${DOCKER_CONTAINERS}

# Show current state of the environment.
status:
	docker-compose ps
	docker-compose top


# =============================================================================
# OTHER COMMAND TARGETS
# =============================================================================
# These commands are specific to this project.

# Check if the environment meets requirements. Requires containers are up.
validate: ensure-fpm
	# Example
	docker-compose exec fpm drush --version

# Reinstall Drupal if required (normally not).
drupal-reinstall: ensure-fpm
	docker-compose exec fpm drush site-install -y minimal --config-dir=../config/sync --account-mail=noreply+proref@reload.dk --account-pass=admin --site-mail=noreply+proref@reload.dk --site-name=ProRef --db-su=root --db-su-pw=root --db-url=mysql://db:db@db/db

# Import the local config into a running Drupal site.
drupal-locale-update: ensure-fpm
	docker-compose exec fpm drush -y locale-check
	docker-compose exec fpm drush -y locale-update

# Run Drupal Console with an arbitrary set of parameters.
# 	Example: make drupal-run CMD=site:status
drupal-run: ensure-fpm
	docker-compose exec fpm drupal ${CMD}

# Run Drush with an arbitrary set of parameters.
# 	Example: make drush-run CMD=status
drush-run: ensure-fpm
	docker-compose exec fpm drush ${CMD}


# =============================================================================
# HELPERS
# =============================================================================
# These targets are usually not run manually.

# Fetch and replace updated containers and db-dump images and run composer install.
update: docker-pull
	docker-compose rm --stop --force ${DOCKER_CONTAINERS}
	docker-compose up -d fpm
	# wait just a bit before proceeding, since the FPM container is not ready right away.
	sleep 2s
	docker-compose exec fpm /bin/bash -c 'cd .. && composer --no-interaction install --optimize-autoloader'
	docker-compose exec fpm drush cache:rebuild
	docker-compose exec fpm drush -y updatedb --entity-updates
	docker-compose exec fpm drush -y config:import

ensure-fpm:
	docker-compose up -d --no-deps fpm

# Pull all images from Docker Hub.
docker-pull:
	docker-compose pull --parallel ${DOCKER_CONTAINERS}
