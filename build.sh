#!/bin/sh

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain

. ./.env

#docker-compose pull
docker-compose build --build-arg GIT_PROXY="${GIT_PROXY}" --pull --parallel #--no-cache
