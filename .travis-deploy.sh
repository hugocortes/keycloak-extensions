#!/bin/bash

DOCKER_HUB=hugocortes/keycloak
DATE=$(date +"%Y%m%d-%H%M")

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker build -t $DOCKER_HUB:latest .
docker tag $DOCKER_HUB:latest $DOCKER_HUB:release-$DATE-${TRAVIS_COMMIT:0:8}

docker push $DOCKER_HUB
