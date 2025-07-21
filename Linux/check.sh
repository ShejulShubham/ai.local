#!/bin/bash

set -e

LOG_DIR="./log"
LOG_FILE="$LOG_DIR/check_sh.log"
mkdir -p "$LOG_DIR"

# Logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

{
  echo "========== Network Access Diagnostic =========="
  echo "Timestamp: $(date)"
  echo "---------------------------------------------------"

  # Get IP from resolv.conf
  NAMESERVER_IP=$(hostname -I | awk '{print $1}')
  echo "Host IP (from resolv.conf): $NAMESERVER_IP"

  # Get fallback IP if needed (Windows host gateway inside WSL)
  WSL_HOST_IP=$(ip route | grep default | awk '{print $3}')

  echo ""
  echo "---- Nginx Container Status ----"
  NGINX_STATUS=$(docker ps --filter "name=nginx-proxy" --filter "status=running" -q)
  if [[ -n "$NGINX_STATUS" ]]; then
    echo "✅ Nginx container is running."
  else
    echo "❌ Nginx container is not running."
  fi

  echo ""
  echo "---- Nginx Proxy Test (http://$NAMESERVER_IP) ----"
  if curl --max-time 5 -s "http://$NAMESERVER_IP" > /dev/null; then
    echo "✅ Successfully reached Nginx proxy at http://$NAMESERVER_IP"
  else
    echo "❌ Failed to reach Nginx proxy at http://$NAMESERVER_IP"
    echo "   Trying fallback IP: $WSL_HOST_IP..."
    if curl --max-time 5 -s "http://$WSL_HOST_IP" > /dev/null; then
      echo "✅ Reached Nginx via fallback IP: http://$WSL_HOST_IP"
    else
      echo "❌ Still failed to reach Nginx on fallback IP."
      echo "   (Check nginx.conf, container port mappings, and firewall settings.)"
    fi
  fi

  echo ""
  echo "---- Ollama API Test (http://$NAMESERVER_IP:11434/api/tags) ----"
  if curl --max-time 5 -s "http://$NAMESERVER_IP:11434/api/tags" | grep -q "models"; then
    echo "✅ Ollama is reachable from WSL."
  else
    echo "❌ Failed to reach Ollama at http://$NAMESERVER_IP:11434"
    echo "   (Is Ollama running and listening on that IP?)"
  fi

  echo ""
  echo "✅ Check completed. Log saved at $LOG_FILE"

} | tee -a "$LOG_FILE"
