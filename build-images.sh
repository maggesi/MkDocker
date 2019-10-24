#!/bin/bash

# Shell variables that need to be configured before running this script:
# DOCKER_REPOSITOR: Name of the repository on Docker Hub
# TOPDIR: folder containing the targets (folders containing Dockerfile)
# TAG: the target (and docker tag), i.e., one of the subfolder of TOPDIR.

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

TAG='environment'
build_image
docker run --rm "$IMAGE" ocamlc -version
docker push "$IMAGE"

TAG='hol-light'
build_image
echo 'ARITH_RULE `2 + a = a + 2`;;' | docker run --rm "$IMAGE" hol_light
docker push "$IMAGE"
