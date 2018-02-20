#!/bin/sh

# Clean Environment & Install Dependencies #

if [[
    ! -x "$(command -v docker)" ||
    ! -x "$(command -v docker-compose)" 
]]; then

    printf "\nYou Need To Install Docker & Docker Compose\n\n"

fi

if [[
    ! -x "$(command -v node)" ||
    ! -x "$(command -v npm)" 
]]; then

    printf "\nYou Need To Install Docker & Docker Compose\n\n"

fi

if [[

    -x "$(command -v docker)" &&
    -x "$(command -v docker-compose)" &&
    -x "$(command -v node)" &&
    -x "$(command -v npm)" 

]]; then

    DOCKER_CONTAINERS=($(docker ps -a -q))
    DOCKER_IMAGES=($(docker image ls -q))
    DOCKER_VOLUMES=($(docker volume ls -q))

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

    npm install
    cp -n docker/env/.worklearn-env.example docker/env/.worklearn-env
    cp -n settings.json.example settings.json
    rm -Rf .meteor/local
    rm -Rf node_modules
    printf "\nEnvironment Cleaned Successfully\n\n"

fi
