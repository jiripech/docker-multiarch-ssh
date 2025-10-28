#!/bin/bash
# This script builds and pushes a multi-architecture Docker image using Docker Buildx.

set -e

if [ "x$1" == "x" ] || [ "$1" == "--help" ]; then
    echo "Usage: $0 <image-name> [ssh-public-key]"
    exit 1
fi

if [ "x$2" == "x" ]; then
    # Check if SSH public keys exist in order of algorithm security preference
    for keyalgs in ed25519 ecdsa rsa dsa; do
        if [ -f ~/.ssh/id_$keyalgs ]; then
            SSH_PUB_KEY_PATH=~/.ssh/id_$keyalgs.pub
            break;
        fi
    done
    SSH_PUB_KEY_ARG=$(cat $SSH_PUB_KEY_PATH 2>/dev/null)
fi

# Build and push the multi-architecture Docker image
# The image file will be bigger than two architecture dependent images due to inclusion of both architectures
# in a single image manifest.
docker buildx build --platform linux/amd64,linux/arm64 \
    --build-arg SSH_PUB_KEY="$SSH_PUB_KEY_ARG" \
    -t $1:latest \
    --push .
