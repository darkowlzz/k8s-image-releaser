#!/usr/bin/env bash

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "$CONTAINER_IMAGE_REPO/$K8S_COMPONENT_NAME:$K8S_REPO_VERSION"
