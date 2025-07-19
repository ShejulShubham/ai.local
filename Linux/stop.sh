#!/bin/bash

LOG_DIR="/debug_log"
LOG_FILE="$LOG_DIR/stop.log"
mkdir -p "$LOG_DIR"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Stopping all running containers..."
CONTAINERS=$(docker ps -q)
if [ -n "$CONTAINERS" ]; then
  docker stop $CONTAINERS
  log "Containers stopped: $CONTAINERS"
else
  log "No running containers to stop."
fi

log "Removing all containers..."
ALL_CONTAINERS=$(docker ps -aq)
if [ -n "$ALL_CONTAINERS" ]; then
  docker rm -f $ALL_CONTAINERS
  log "Containers removed: $ALL_CONTAINERS"
else
  log "No containers to remove."
fi

# log "Cleaning up unused Docker resources..."
# docker system prune -af --volumes >> "$LOG_FILE" 2>&1
# log "Docker system pruned."

# Optional: Stop Docker service on Linux if available
if command -v systemctl >/dev/null 2>&1; then
  if systemctl is-active --quiet docker; then
    sudo systemctl stop docker
    log "Docker service stopped via systemctl."
  else
    log "Docker service not running or systemd not available."
  fi
fi

# WSL shutdown if inside WSL
if grep -qEi "(microsoft|wsl)" /proc/version &>/dev/null; then
  log "Detected WSL environment. Shutting down WSL..."
  powershell.exe -Command "wsl --shutdown"
fi

log "Docker shutdown and cleanup complete."
