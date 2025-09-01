#!/bin/bash

# Build and run fish-speech with volume mapping for development

set -e

echo "Building fish-speech development container with volume mapping..."
podman-compose -f docker-compose.volume.yml build

echo "Starting fish-speech development container..."
podman-compose -f docker-compose.volume.yml up -d

echo "Development container started!"
echo "You can now:"
echo "  - Edit files in fish_speech/, tools/, docs/ directories and they will be reflected in the container"
echo "  - Access the web UI at http://localhost:7860"
echo "  - View logs with: podman-compose -f docker-compose.volume.yml logs -f"
echo "  - Stop with: podman-compose -f docker-compose.volume.yml down"
