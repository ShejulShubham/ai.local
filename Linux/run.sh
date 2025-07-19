#!/bin/bash

set -e

# echo "Starting Docker..."
# systemctl start docker    

# Extract host IP (used by WSL2 to access host services)
HOST_IP=$(grep nameserver /etc/resolv.conf | awk '{print $2}')

# Write to .env file
ENV_FILE=".env"
echo "OLLAMA_BASE_URL=http://$HOST_IP:11434" > "$ENV_FILE"

echo ".env file created with:"
cat "$ENV_FILE"

echo "Command used for staring the containers:"
echo "sudo docker compose --env-file "$ENV_FILE" -f docker-compose.yml up -d"

echo "Starting your containers using docker-compose..."
docker compose --env-file "$ENV_FILE" -f docker-compose.yml up -d

echo "Containers are now running."
