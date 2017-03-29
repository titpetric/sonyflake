#!/bin/bash
set -e
echo "> Adding Docker Hub Login"
docker login -u $DOCKER_REGISTRY_USERNAME -p $DOCKER_REGISTRY_PASSWORD
GITVERSION=$(git rev-list HEAD | head -n 1 | cut -c1-6)
make -e GITVERSION=$GITVERSION
