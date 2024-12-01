#!/bin/bash

echo "Running pre_configure.sh script"

# Custom base directory
export BASE_DIR="/${BASE_DIR_NAME}"

# Create needed directories
mkdir "${BASE_DIR}"
mkdir "${BASE_DIR}"/{tools,setup,build,tmp,config}

# Move corrupted sources file
mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak

# Move resolve.conf since we are running in chroot and systemd services cannot run in it.
mv /etc/resolv.conf /etc/resolv.conf.orig # points to system-resolved

# Create our own resolv.conf
touch /etc/resolv.conf
echo "nameserver 8.8.8.8" | tee /etc/resolv.conf >/dev/null
