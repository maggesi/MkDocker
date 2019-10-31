#!/bin/bash

# Shell variables that need to be configured before running this script:
# DOCKER_REPOSITOR: Name of the repository on Docker Hub
# TOPDIR: folder containing the targets (folders containing Dockerfile)

set -ev

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
export TOPDIR=$(pwd)
export BRANCH="$TRAVIS_PULL_REQUEST_BRANCH"
if [ -z "$BRANCH" ]; then export BRANCH="$TRAVIS_BRANCH"; fi
echo "Branch is $BRANCH."

function build_image () {
    IMAGE="$DOCKER_REPOSITORY:$TAG-$BRANCH"
    echo "Tag is $TAG.  Image is $IMAGE"
    cd "$TOPDIR/images/$TAG"
    docker build -t "$TAG" .
    docker tag "$TAG" "$IMAGE"
    docker push "$IMAGE"
}

function push_image () {
    if [ "$BRANCH" == "master" ]
    then docker push "$IMAGE"
    fi
}

TAG='environment'
build_image

echo "DEBUG: Docker container list"
docker image list

docker tag "$TAG" "$DOCKER_REPOSITORY:environment"

echo "DEBUG: Docker container list"
docker image list

docker run --rm "$IMAGE" ocamlc -version
push_image

echo "DEBUG: Docker container list"
docker image list

TAG='hol-light'
build_image
docker run --rm -i "$IMAGE" /bin/sh -c hol_light < "$TOPDIR/test_script.ml"
push_image