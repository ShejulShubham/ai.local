#!/bin/bash

set -e

LOG_DIR="./log"
LOG_FILE="$LOG_DIR/stop_sh.log"
mkdir -p "$LOG_DIR"

# Logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

{
  echo ""
  echo "========== Stopping Containers and Cleaning Up =========="
  echo "Timestamp: $(date)"
  echo "----------------------------------------------------------"

  log "Checking for running Docker containers..."
  CONTAINERS=$(docker ps -q)

  if [ -n "$CONTAINERS" ]; then
    log "Stopping running containers..."
    docker stop $CONTAINERS
    log "✅ Containers stopped: $CONTAINERS"
  else
    log "ℹ️ No running containers found."
  fi

  echo ""
  log "Checking for all containers (running or exited)..."
  ALL_CONTAINERS=$(docker ps -aq)

  if [ -n "$ALL_CONTAINERS" ]; then
    log "Removing all containers..."
    docker rm -f $ALL_CONTAINERS
    log "✅ All containers removed."
  else
    log "ℹ️ No containers to remove."
  fi

  echo ""
  log "Checking if Docker service can be stopped..."

  if command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active --quiet docker; then
      log "Stopping Docker service..."
      sudo systemctl stop docker
      log "✅ Docker service stopped."
    else
      log "ℹ️ Docker service is already inactive."
    fi
  else
    log "⚠️ systemctl not found. Skipping Docker service stop."
  fi

  echo ""
  log "🧹 Cleanup complete."
  echo "=========================================================="
  echo "Finished running: stop.sh script"
  echo ""

} | tee -a "$LOG_FILE"
