#!/bin/sh

# Cleans Docker Environment For Builds #

docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker image ls -q)
docker volume rm $(docker volume ls -q)
