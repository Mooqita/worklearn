#!/bin/sh

# Clean Environment & Install Dependencies #

DOCKER_CONTAINERS=$(docker ps -a -q)
DOCKER_IMAGES=$(docker image ls -q)
DOCKER_VOLUMES=$(docker volume ls -q)

if [ ${#DOCKER_CONTAINERS[@]} -gt 0 ]; then
    docker stop $DOCKER_CONTAINERS
    docker rm $DOCKER_CONTAINERS
fi

if [ ${#DOCKER_IMAGES[@]} -gt 0 ]; then
    docker rmi $DOCKER_IMAGES
fi

if [ ${#DOCKER_VOLUMES[@]} -gt 0 ]; then
    docker volume rm $DOCKER_VOLUMES
fi

rm -Rf .meteor/local
rm -Rf node_modules
cp -n docker/env/.worklearn-env.example docker/env/.worklearn-env
cp -n settings.json.example settings.json
npm install
printf "\nEnvironment Cleaned Successfully\n\n"
