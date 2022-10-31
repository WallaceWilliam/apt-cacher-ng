#!/bin/sh

#docker run --name apt-cacher-ng -d --restart=unless-stopped -p 3142:3142 -v $PWD/cache:/var/cache/apt-cacher-ng sameersbn/apt-cacher-ng:latest

export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export BUILDKIT_PROGRESS=plain

#docker-compose pull
docker-compose build --pull
docker-compose up --remove-orphans -d
#docker-compose down
sleep 5
docker logs cacher -n 100
