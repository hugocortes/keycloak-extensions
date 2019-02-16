#!/bin/bash

echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

docker build -t $DOCKER_HUB:$TRAVIS_TAG .
docker tag $DOCKER_HUB:$TRAVIS_TAG $DOCKER_HUB:latest

docker push $DOCKER_HUB
