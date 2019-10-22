#!/bin/bash

# Shell variables that need to be configured before running this script:
# DOCKER_REPOSITOR: Name of the repository on Docker Hub
# TOPDIR: folder containing the targets (folders containing Dockerfile)
# TAG: the target (and docker tag), i.e., one of the subfolder of TOPDIR.

set -ev
IMAGE="$DOCKER_REPOSITORY:$TAG"
cd $TOPDIR/images/$TAG
<<<<<<< HEAD
docker pull "$IMAGE" || true    # Use cache if one image already exists
docker build --cache-from "$IMAGE" --tag "$IMAGE" .
=======
docker pull "$IMAGE" || true
docker build --cache-from "$IMAGE" -t $TAG .
docker tag $TAG "$IMAGE"
>>>>>>> parent of 043e5eb... Collapse two docker commands in one.
docker push "$IMAGE"