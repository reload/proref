#!/usr/bin/env bash

##
# Common utilities for the docker shell-scripts.

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Conditional include of .env.
if [[ -f "${SCRIPT_DIR}/../../.env" ]]; then
    # shellcheck source=../../.env disable=SC1091
    source "${SCRIPT_DIR}/../../.env"
fi

# Enable docker-sync if:
# - NO_DOCKER_SYNC is not set
# - We can find the executable in path
# - It is executable
# - we can find a docker-sync.yml
DOCKER_SYNC=
if [[ -z "${NO_DOCKER_SYNC:-}" && $(type -P "docker-sync") && -f "${SCRIPT_DIR}/../../docker-sync.yml" ]]; then
    DOCKER_SYNC=1
fi

# Enable NFS if:
# - NO_NFS is not set
# - Host is running macOS
# - we can find a docker-compose-mac.yml
NFS=
if [[ -z "${NO_NFS:-}" && `uname -s` -eq 'Darwin' && -f "${SCRIPT_DIR}/../../docker-compose-mac.yml" ]]; then
    NFS=1
fi

# Determine of docker-compose override exists.
COMPOSER_OVERRIDE=
if [[ -f "${SCRIPT_DIR}/../../docker-compose.override.yml" ]]; then
    COMPOSER_OVERRIDE=1;
fi

# Determine if we have Dory.
DORY=
if [[ $(type -P "dory") ]]; then
    DORY=1
fi

# Echo green
echoc () {
    GREEN=$(tput setaf 2)
    RESET=$(tput sgr0)
	echo -e "${GREEN}$1${RESET}"
}
