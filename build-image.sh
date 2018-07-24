#!/bin/bash

set -o errexit

readonly IMAGE_NAME="dtone-3221"
readonly IMAGE_PREFIX="${IMAGE_PREFIX:-tmoreira2020}"
readonly IMAGE_TAG="${IMAGE_TAG:-latest}"

main() {
  build_image "$@"
}

build_image() {
  docker build \
    --build-arg DT_TENANT="$1" \
    --build-arg DT_API_TOKEN="$2" \
    --tag "$IMAGE_PREFIX/$IMAGE_NAME:$IMAGE_TAG" \
    --tag "$IMAGE_PREFIX/$IMAGE_NAME:local" \
    $DIR \
    --squash \
    "."
}

main "$@"
