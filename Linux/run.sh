#!/bin/bash

set -e

ENV_FILE=".env"
LOG_DIR="./log"
LOG_FILE="$LOG_DIR/run_sh.log"
mkdir -p "$LOG_DIR"

# Logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

{
    echo ""
    echo "========== Starting the Containers =========="
    echo "Timestamp: $(date)"
    echo "---------------------------------------------------"

    echo "Starting Docker..."
    systemctl start docker  

    HOST_IP=$(hostname -I | awk '{print $1}')
    echo "Local device IP: $HOST_IP"

    echo "OLLAMA_BASE_URL=http://$HOST_IP:11434" > "$ENV_FILE"

    echo ""
    echo ".env file created with:"
    cat "$ENV_FILE"

    echo ""
    echo "Command used for starting the containers:"
    echo "sudo docker compose --env-file $ENV_FILE -f docker-compose.yml up -d"

    echo "Starting your containers using docker-compose..."
    docker compose --env-file "$ENV_FILE" -f docker-compose.yml up -d

    echo "✅ Containers are now running. Log saved at $LOG_FILE"
    echo ""
    echo "Finished running: run.sh file"
} | tee -a "$LOG_FILE"
