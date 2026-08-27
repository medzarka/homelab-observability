#!/usr/bin/env bash
set -e

# Generates a unique Docker Node ID using the hostname and a random 4-byte hex string
# This ensures that when the same compose file is run on multiple nodes, the containers
# get unique names on the overlay network, preventing DNS conflicts.

UNIQUE_ID="$(hostname)-$(head -c 4 /dev/urandom | xxd -p)"

# Write to .env file in the current directory
echo "DOCKER_NODE_ID=${UNIQUE_ID}" >> .env

echo "✅ Generated unique ID: ${UNIQUE_ID}"
echo "✅ Appended DOCKER_NODE_ID to .env file."
echo "You can now use \${DOCKER_NODE_ID} in your docker-compose.yaml files!"
