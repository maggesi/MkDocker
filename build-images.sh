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
docker run --rm "$IMAGE" ocamlc -version
push_image

TAG='hol-light'
build_image
echo 'let FOO_THM = ARITH_RULE `b = 0 ==> (a + b) - a = 0`;;\nloads "update_database.ml";;\nsearch[`x = 0 ==> (x + y) - x = 0];;\nassert (length it >= 1);;\nreport "Done!";;' | docker run --rm -i "$IMAGE" hol_light
push_image