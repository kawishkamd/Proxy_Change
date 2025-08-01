# Proxy Setup Script for Debian-Based Linux Systems

This script allows users to easily add or change proxy settings on a Debian-based Linux system. It prompts the user for a proxy server IP address and port number, validates the inputs, and then updates the system's environment settings accordingly.

## Features

- Validates the provided IP address and port number.
- Backs up the existing `/etc/environment` file before making changes.
- Appends the new proxy settings to the `/etc/environment` file.
- User-friendly prompts and error messages.
- Clear instructions for the user to reboot or log out for the changes to take effect.

## Prerequisites

- A Debian-based Linux distribution (e.g., Ubuntu, Debian).
- `bash` shell.
- `sudo` privileges to modify the `/etc/environment` file.

## Usage

### Step 1: Download the Script

Save the script to a file, for example, `set_proxy.sh`.

### Step 2: Make the Script Executable

Open a terminal and run the following command to make the script executable:

```sh
chmod +x set_proxy.sh
```
