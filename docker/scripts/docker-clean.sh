#!/bin/sh

# Clean Environment & Install Dependencies #

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker image ls -q)
docker volume rm $(docker volume ls -q)
rm -Rf .meteor/local
rm -Rf node_modules
npm install
cp -n docker/env/.worklearn-env.example docker/env/.worklearn-env
cp -n settings.json.example settings.json
