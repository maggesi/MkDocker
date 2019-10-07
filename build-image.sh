#!/bin/bash

# Shell variables that need to be configured before running this script:
# DOCKER_REPOSITOR
# TOPDIR (directory containing images)
# TAG    (subdirectory of images and tags of the images)

set -ev
IMAGE="$DOCKER_REPOSITORY:$TAG"
cd $TOPDIR/images/$TAG
docker pull "$IMAGE" || true
docker build --cache-from "$IMAGE" -t $TAG .
docker tag $TAG "$IMAGE"
docker push "$IMAGE"