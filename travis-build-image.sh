echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker build -t hol-light-environment .
docker images
docker push hol-light-environment
