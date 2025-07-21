#!/bin/bash

LOG_DIR="/log"
LOG_FILE="$LOG_DIR/stop_sh.log"
mkdir -p "$LOG_DIR"
# touch "$LOG_FILE"

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
fi

# Optional: Stop Docker service on Linux if available
if command -v systemctl >/dev/null 2>&1; then
  if systemctl is-active --quiet docker; then
    sudo systemctl stop docker
  fi
fi

# WSL shutdown if inside WSL
if grep -qEi "(microsoft|wsl)" /proc/version &>/dev/null; then
  
  powershell.exe -Command "wsl --shutdown"
fi