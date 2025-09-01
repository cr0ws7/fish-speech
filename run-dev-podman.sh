#!/bin/bash

# Direct podman run command with GPU support and volume mapping for development
# This is equivalent to your original command but with source code mounted as volumes

set -e

IMAGE_NAME="fish-speech:dev-volume"

echo "Running fish-speech development container with GPU support and volume mapping..."
echo "Source code directories (fish_speech/, tools/, docs/) will be mapped from host"
echo "Press Ctrl+C to stop the container"
echo ""

podman run --rm \
    --device nvidia.com/gpu=all \
    -it \
    -p 7860:7860 \
    -v ./fish_speech:/opt/fish-speech/fish_speech \
    -v ./tools:/opt/fish-speech/tools \
    -v ./docs:/opt/fish-speech/docs \
    -v ./entrypoint.sh:/opt/fish-speech/entrypoint.sh \
    -v ./pyproject.toml:/opt/fish-speech/pyproject.toml \
    -v ./README.md:/opt/fish-speech/README.md \
    -v ./.project-root:/opt/fish-speech/.project-root \
    -v ./checkpoints:/opt/fish-speech/checkpoints \
    -e CUDA_ENABLED=true \
    -e GRADIO_SERVER_NAME=0.0.0.0 \
    -w /opt/fish-speech \
    $IMAGE_NAME
