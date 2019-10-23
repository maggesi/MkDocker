#!/bin/bash

# Shell variables that need to be configured before running this script:
# DOCKER_REPOSITOR: Name of the repository on Docker Hub
# TOPDIR: folder containing the targets (folders containing Dockerfile)
# TAG: the target (and docker tag), i.e., one of the subfolder of TOPDIR.

set -ev

function setup_environment () {
    echo "Setup environment"
    IMAGE="$DOCKER_REPOSITORY:$TAG-$BRANCH"
    export BRANCH="$TRAVIS_PULL_REQUEST_BRANCH"
    if [ -z "$BRANCH" ]; then export BRANCH="$TRAVIS_BRANCH"; fi
    echo "Branch is $BRANCH.  Tag is $TAG.  Image is $IMAGE"
}

function build_image () {
    echo 'Build image'
    echo "From $(pwd) go to $TOPDIR/images/$TAG"
    cd "$TOPDIR/images/$TAG"
    # Use cache if one image already exists
    if [ "$CACHE" = "yes" ] && [ docker pull "$IMAGE" ]
    then
        docker build --cache-from "$IMAGE" -t "$TAG" .
    else
        docker build -t "$TAG" .
    fi
    docker tag "$TAG" "$IMAGE"
    docker push "$IMAGE"
}

function test_image () {
    echo "Test image"
    docker run --rm "$IMAGE" ocamlc -version
}

function push_image () {
    echo "Push image"
    docker push "$IMAGE"
}

TAG='environment'
CACHE='yes'
setup_environment
build_image
test_image
push_image

TAG='hol_light'
CACHE='no'
setup_environment
build_image
test_image
push_image

if [ "$BRANCH" == "master" ]
then
  docker tag "$IMAGE" "$DOCKER_REPOSITORY:latest"
  docker push "$DOCKER_REPOSITORY:latest"
  echo 'New latest image sent'
else
  echo 'Do not send new latest image'
fi

