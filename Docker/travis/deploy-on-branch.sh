#!/bin/bash

DATE=$(date +"%Y%m%d-%H%M")

echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

docker build -t $DOCKER_HUB:branch-$DATE-${TRAVIS_COMMIT:0:8} .

docker push $DOCKER_HUB
