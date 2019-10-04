docker build -t hol-light-environment .
docker tag hol-light-environment "$DOCKER_USERNAME"/hol-light-environment
docker push "$DOCKER_USERNAME"/hol-light-environment
