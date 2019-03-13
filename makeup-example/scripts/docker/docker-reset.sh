#!/usr/bin/env bash

##
# Removes all containers and starts up a clean environment
#
# Invokes site-reset.sh after container startup.

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=_docker-common.sh
source "${SCRIPT_DIR}/_docker-common.sh"

# Hostname to send a request to to warm up the cache-cleared site.
HOST="localhost"
WEB_CONTAINER="web"

# Start off at the root of the project.
cd "$SCRIPT_DIR/../../"

# Preemptive sudo lease - to let you go out and grab a coffee while the script
# runs.
sudo echo ""

if [[ $DOCKER_SYNC ]]; then
    echoc "*** Forcing docker sync - if this is the first sync it will take minutes"
    docker-sync start || true
    docker-sync sync
fi

if [[ $DORY ]]; then
    dory up
fi

# Clear all running containers.
echoc "*** Removing existing containers"
# The last docker-compose down -v removes various named volumes (datadir and
# npm-cache)
docker-compose kill && docker-compose rm -v -f && docker-compose down --remove-orphans -v

# Start up containers in the background and continue immediately
echoc "*** Starting new containers"
if [[ $COMPOSER_OVERRIDE ]]; then
    if [[ $NFS ]]; then
        export COMPOSE_FILE = docker-compose.yml:docker-compose-mac.yml:docker-compose.override.yml
    fi
    if [[ $DOCKER_SYNC ]]; then
        export COMPOSE_FILE = docker-compose.yml:docker-compose-dev.yml:docker-compose.override.yml
    fi
else
    if [[ $NFS ]]; then
        export COMPOSE_FILE = docker-compose.yml:docker-compose-mac.yml
    fi
    if [[ $DOCKER_SYNC ]]; then
        export COMPOSE_FILE = docker-compose.yml:docker-compose-dev.yml
    fi
fi
docker-compose up --remove-orphans -d

# Perform the drupal-specific reset
echoc "*** Resetting Drupal"
"${SCRIPT_DIR}/site-reset.sh"

echoc "*** Warming cache by doing an initial request"
docker-compose exec ${WEB_CONTAINER} curl --silent --output /dev/null -H "Host: ${HOST}" localhost
