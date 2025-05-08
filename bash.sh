#!/bin/bash

# Require root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Validate IP
validate_ip() {
  local ip="$1"
  local octet="(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
  [[ $ip =~ ^$octet\.$octet\.$octet\.$octet$ ]] || return 1
  return 0
}

# Validate Port
validate_port() {
  local port="$1"
  [[ $port =~ ^[0-9]+$ ]] && ((port >= 1 && port <= 65535))
}

# Remove existing proxy lines
clear_proxy_settings() {
  local env_file="/etc/environment"
  [[ -f "$env_file" ]] || { echo "Error: $env_file does not exist" >&2; return 1; }

  local backup_file="${env_file}.bak.$(date +%Y%m%d%H%M%S)"
  cp "$env_file" "$backup_file" || { echo "Error: Failed to create backup" >&2; return 1; }

  sed -i '/_proxy=/Id' "$env_file" || { echo "Error: Failed to remove proxy settings" >&2; return 1; }

  echo "Proxy settings cleared. Backup: $backup_file"
}

# Set proxy
set_proxy_settings() {
  local ip="$1"
  local port="$2"

  if ! clear_proxy_settings; then
    echo "Error: Could not clear existing proxy settings." >&2
    return 1
  fi

  local temp_file
  temp_file=$(mktemp) || { echo "Error: Cannot create temp file." >&2; return 1; }
  trap 'rm -f "$temp_file"' EXIT

  cat <<EOF > "$temp_file"
export http_proxy="http://${ip}:${port}/"
export https_proxy="http://${ip}:${port}/"
export ftp_proxy="ftp://${ip}:${port}/"
export rsync_proxy="rsync://${ip}:${port}/"
export no_proxy="localhost,127.0.0.1,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12,::1,*.local"
export HTTP_PROXY="http://${ip}:${port}/"
export HTTPS_PROXY="http://${ip}:${port}/"
export FTP_PROXY="ftp://${ip}:${port}/"
export RSYNC_PROXY="rsync://${ip}:${port}/"
export NO_PROXY="localhost,127.0.0.1,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12,::1,*.local"
EOF

  tee -a /etc/environment < "$temp_file" > /dev/null || {
    echo "Error: Failed to write proxy settings" >&2
    return 1
  }

  echo "Proxy set to ${ip}:${port}"
}

# Menu
clear
echo "=== Proxy Configuration ==="
echo "1. Set Proxy"
echo "2. Unset Proxy"
read -rp "Choose [1/2]: " choice

if [[ "$choice" == "1" ]]; then
  while true; do
    read -rp "Enter proxy IP: " ip
    validate_ip "$ip" && break || echo "Invalid IP! Must be in format xxx.xxx.xxx.xxx" >&2
  done
  while true; do
    read -rp "Enter proxy port: " port
    validate_port "$port" && break || echo "Invalid port! Must be between 1 and 65535" >&2
  done
  set_proxy_settings "$ip" "$port"
elif [[ "$choice" == "2" ]]; then
  clear_proxy_settings
  echo "Proxy unset."
else
  echo "Invalid choice." >&2
  exit 1
fi

echo "Note: Reboot or re-login to apply changes."
