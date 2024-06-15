#!/bin/bash

# Function to validate IP address
validate_ip() {
  local ip="$1"
  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
      if ((octet > 255)); then
        return 1
      fi
    done
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

# Function to add proxy settings
add_proxy_settings() {
  local ip_address="$1"
  local port="$2"

  local proxy_settings="
export http_proxy=\"http://${ip_address}:${port}/\"
export https_proxy=\"http://${ip_address}:${port}/\"
export ftp_proxy=\"ftp://${ip_address}:${port}/\"
export rsync_proxy=\"rsync://${ip_address}:${port}/\"
export no_proxy=\"localhost,127.0.0.1,192.168.1.1,::1,*.local\"
export HTTP_PROXY=\"http://${ip_address}:${port}/\"
export HTTPS_PROXY=\"http://${ip_address}:${port}/\"
export FTP_PROXY=\"ftp://${ip_address}:${port}/\"
export RSYNC_PROXY=\"rsync://${ip_address}:${port}/\"
export NO_PROXY=\"localhost,127.0.0.1,192.168.1.1,::1,*.local\"
"

  # Backup existing /etc/environment
  sudo cp /etc/environment /etc/environment.bak

  # Append proxy settings to /etc/environment
  echo "$proxy_settings" | sudo tee -a /etc/environment

  echo "Proxy settings applied successfully!"
}

# Main script
clear
echo "Welcome to the Proxy Setup Script"

# Prompt user for IP address
while true; do
  read -p "Enter the IP address of the proxy server: " ip_address
  if validate_ip "$ip_address"; then
    break
  else
    echo "Invalid IP address. Please enter a valid IP address in the format xxx.xxx.xxx.xxx where xxx is between 0 and 255."
  fi
done

# Prompt user for port
while true; do
  read -p "Enter the port number of the proxy server: " port
  if validate_port "$port"; then
    break
  else
    echo "Invalid port number. Please enter a valid port number between 1 and 65535."
  fi
done

# Add proxy settings
add_proxy_settings "$ip_address" "$port"

echo "Please reboot your system or log out and log back in for changes to take effect."
