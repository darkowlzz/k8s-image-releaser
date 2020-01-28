#!/usr/bin/env bash

set -Eeuxo pipefail

# Container image repo where the build image it pushed.
CONTAINER_IMAGE_REPO="${CONTAINER_IMAGE_REPO:-}"
# k8s repo version to build the component from.
K8S_REPO_VERSION="${K8S_REPO_VERSION:-master}"
# k8s component name to be build.
K8S_COMPONENT_NAME="${K8S_COMPONENT_NAME:-}"

# Generate dockerfile for the target binary.
# Copy the created binary into a docker container image.
generate_dockerfile() {
    cat <<EOF
FROM gcr.io/distroless/base-debian10
COPY $K8S_COMPONENT_NAME /usr/local/bin/$K8S_COMPONENT_NAME
CMD ["/bin/sh", "-c"]
EOF
}

# Build k8s binary.
git clone --branch $K8S_REPO_VERSION https://github.com/kubernetes/kubernetes $GOPATH/src/k8s.io/kubernetes --depth=1
pushd "$GOPATH/src/k8s.io/kubernetes"
    make WHAT=cmd/$K8S_COMPONENT_NAME
    generate_dockerfile > "Dockerfile"
    docker build -t "$CONTAINER_IMAGE_REPO/$K8S_COMPONENT_NAME:$K8S_REPO_VERSION" -f Dockerfile _output/bin/
popd
