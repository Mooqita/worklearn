#!/bin/sh

# Clean Environment & Install Dependencies #

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker image ls -q)
docker volume rm $(docker volume ls -q)
rm -Rf .meteor/local
rm -Rf node_modules
npm install
