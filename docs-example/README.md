Readme for Exmaple Project
==========================

# Overview
The Exmaple project has a very interesting architecture. It consists of 3 distinct parts: the top, the center, and the bottom part. Deserunt pariatur non ad mollit elit elit et ipsum anim nostrud irure velit do. Velit occaecat cillum ea commodo. Ut Lorem aliqua irure incididunt nulla laboris velit cillum fugiat deserunt consequat ipsum. Exercitation sint in nostrud esse quis elit.

In-depth documentation of the architecture is available in the [docs folder](./docs/).

# Local development
To get started with this project, simply check out the code and run `make up`.

The initial start will take a while as Docker will fetch a fresh db dump from Google's Container Registry.

## Requirements
- Docker
- docker-compose
- Google Cloud SDK component ([install instructions](https://reload.atlassian.net/wiki/spaces/RW/pages/659488769/Docker+database+dumps+fra+Google+Container+Registry+GCR)) and authenticated `gcloud` component
- GNU make

The project supports Dory and `docker-sync`.

## Resetting your setup
To nuke your setup and start over (including databases, container volumes etc) run `make reset`.

## Testing emails
Mailhog is available as a container, and mails are automatically directed there. You can access Mailhog's webinterface on [mailhog.exmaple.docker:8025](http://mailhog.exmaple.docker:8025).

## Working with the frontend
The `node` container will continously watch for changes in the `frontend/` folder once it is up. So any changes to the frontend assets will get rebuilt automatically. The compiled assets are not part of the Git repo.

To learn more about how the frontend works, go to [docs/frontend.md](./docs/frontend.md).

## Unit tests
The `tests` container will execute tests continuously on changes. You can tail the log of that container with `docker-compose logs -f tests` to monitor the state of the tests during development. They are also run on CircleCI post-commit.

# Production setup

The project is hosted on Platform.sh. Pushing any branch to remote builds a fully functional test environment for that branch only. You can find the URL on the project page, or use Platforms CLI via `platform environment:info` to see the publich URL.

# Deploying

fsdsf