#!/bin/bash

# Function to validate IP address
validate_ip() {
  local ip="$1"
  if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  else
    return 1
  fi
}

# Function to validate port
validate_port() {
  local port="$1"
  if [[ $port =~ ^[0-9]+$ ]] && ((port >= 1 && port <= 65535)); then
    return 0
  else
    return 1
  fi
}

# Prompt user for IP address
while true; do
  read -p "Enter the IP address: " ip_address
  if validate_ip "$ip_address"; then
    break
  else
    echo "Invalid IP address. Please enter a valid IP address."
  fi
done

# Prompt user for port
while true; do
  read -p "Enter the port: " port
  if validate_port "$port"; then
    break
  else
    echo "Invalid port. Please enter a valid port number (1-65535)."
  fi
done

# Construct proxy settings with user input
proxy_settings="
export http_proxy=\"http://${ip_address}:${port}/\"
export ftp_proxy=\"ftp://${ip_address}:${port}/\"
export rsync_proxy=\"rsync://${ip_address}:${port}/\"
export no_proxy=\"localhost,127.0.0.1,192.168.1.1,::1,*.local\"
export HTTP_PROXY=\"http://${ip_address}:${port}/\"
export FTP_PROXY=\"ftp://${ip_address}:${port}/\"
export RSYNC_PROXY=\"rsync://${ip_address}:${port}/\"
export NO_PROXY=\"localhost,127.0.0.1,192.168.1.1,::1,*.local\"
export https_proxy=\"http://${ip_address}:${port}/\"
export HTTPS_PROXY=\"http://${ip_address}:${port}/\"
"

# Append to /etc/environment
echo "$proxy_settings" | sudo tee -a /etc/environment

echo "Proxy settings applied successfully!"
