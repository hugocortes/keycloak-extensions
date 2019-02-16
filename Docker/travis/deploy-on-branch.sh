#!/bin/bash

function bell() {
  while true; do
    echo -e "\a"
    sleep 60
  done
}

DATE=$(date +"%Y%m%d-%H%M")

echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
bell & docker build -t $DOCKER_HUB:branch-$DATE-${TRAVIS_COMMIT:0:8} .
docker push $DOCKER_HUB

exit $?
