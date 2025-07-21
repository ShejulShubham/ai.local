#!/bin/bash

set -e

LOG_DIR="/log"
LOG_FILE="$LOG_DIR/run_sh.log"
mkdir -p "$LOG_DIR"
# touch "$LOG_FILE"

{
    echo ""

    echo "========== Starting the Containers =========="
    echo "Timestamp: $(date)"
    echo "---------------------------------------------------"

    echo "Starting Docker..."
    systemctl start docker  


    # Local device IP on the LAN (e.g. 192.168.1.42)
    HOST_IP=$(hostname -I | awk '{print $1}')

    echo "Local device IP: $HOST_IP"

    # Write to .env file
    ENV_FILE="/tmp/.env"
    echo "OLLAMA_BASE_URL=http://$HOST_IP:11434" > "$ENV_FILE"

    echo ""

    echo ".env file created with:"
    cat "$ENV_FILE"

    echo ""

    echo "Command used for staring the containers:"
    echo "sudo docker compose --env-file "$ENV_FILE" -f docker-compose.yml up -d"

    echo "Starting your containers using docker-compose..."
    docker compose --env-file "$ENV_FILE" -f docker-compose.yml up -d

    echo "Containers are now running."
    echo "✅ Containers are now running. Log saved at $LOG_FILE"

    echo ""
    echo "Finished running: run.sh file"
} | tee "$LOG_FILE"
