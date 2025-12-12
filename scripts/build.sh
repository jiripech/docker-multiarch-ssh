#!/bin/bash
# This script builds and pushes a multi-architecture Docker image using Docker Buildx.

set -e

# Resolve script directory for reliable asset location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
DOCKER_ASSETS="$REPO_ROOT/docker"

if [ "x$1" == "x" ] || [ "$1" == "--help" ]; then
    echo "Usage: $0 <image-name> [ssh-public-key-algorithm]"
    exit 1
fi

SSH_PUB_KEY_PATH=""
if [ "x$2" == "x" ]; then
    # Check if SSH public keys exist in order of algorithm security preference
    for keyalgs in ed25519 ecdsa rsa dsa; do
        if [ -f ~/.ssh/id_$keyalgs ] && [ -f ~/.ssh/id_$keyalgs.pub ]; then
            SSH_PUB_KEY_PATH=~/.ssh/id_$keyalgs.pub
            break;
        fi
    done
else
    SSH_PUB_KEY_PATH=~/.ssh/id_$2.pub
fi

if [ -z "$SSH_PUB_KEY_PATH" ] || [ ! -f "$SSH_PUB_KEY_PATH" ]; then
    echo "Error: Could not find SSH public key. Please specify a valid algorithm or ensure default keys exist."
    exit 1
fi

echo "Using SSH public key from $SSH_PUB_KEY_PATH"

# Create a temporary directory for the build context
BUILD_CONTEXT=$(mktemp -d /tmp/docker-build-context.XXXXXX)
echo "Created temporary build context at $BUILD_CONTEXT"

# cleanup function
cleanup() {
    echo "Cleaning up temporary build context..."
    rm -rf "$BUILD_CONTEXT"
}
trap cleanup EXIT

# Prepare build context
echo "Copying assets to build context..."
cp "$DOCKER_ASSETS/Dockerfile" "$BUILD_CONTEXT/"
cp "$DOCKER_ASSETS/sshd_config" "$BUILD_CONTEXT/"
cat "$SSH_PUB_KEY_PATH" > "$BUILD_CONTEXT/authorized_keys"

# Build and push the multi-architecture Docker image
# The image file will be bigger than two architecture dependent images due to inclusion of both architectures
# in a single image manifest.
echo "Starting Docker build..."
docker buildx build --platform linux/amd64,linux/arm64 -t $1:latest --push "$BUILD_CONTEXT"
