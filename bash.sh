#!/bin/bash

proxy_settings="
export http_proxy=\"http://192.168.8.157:8080/\"
export ftp_proxy=\"ftp://192.168.8.157:8080/\"
export rsync_proxy=\"rsync://192.168.8.157:8080/\"
export no_proxy=\"localhost,127.0.0.1,192.168.1.1,::1,*.local\"
export HTTP_PROXY=\"http://192.168.8.157:8080/\"
export FTP_PROXY=\"ftp://192.168.8.157:8080/\"
export RSYNC_PROXY=\"rsync://192.168.8.157:8080/\"
export NO_PROXY=\"localhost,127.0.0.1,192.168.1.1,::1,*.local\"
export https_proxy=\"http://192.168.8.157:8080/\"
export HTTPS_PROXY=\"http://192.168.8.157:8080/\"
"

# Append to /etc/environment
echo "$proxy_settings" | sudo tee -a /etc/environment

# Append to .bashrc for the current user
echo "$proxy_settings" >> ~/.bashrc

# Source .bashrc to apply changes immediately
source ~/.bashrc

echo "Proxy settings applied successfully!"
