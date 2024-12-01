#!/bin/bash

# Remove the temp resolv.conf file created to access networl in chroot
rm -rf /etc/resolv.conf
mv /etc/resolv.conf.orig /etc/resolv.conf # Link back to original symlink to system-resolved

export BASE_DIR="/${BASE_DIR_NAME}"

chown -R ${ADMIN_USER}:${ADMIN_GROUP} "${BASE_DIR}"

CLOUD_INIT_CONFIG="/etc/cloud/cloud.cfg"

# Check if the config file exists
if [ ! -f "$CLOUD_INIT_CONFIG" ]; then
  echo "cloud-init config file not found."
  exit 1
fi

cp "$CLOUD_INIT_CONFIG" "$CLOUD_INIT_CONFIG.bak"

# Remove default user creation
sed -i '/^users:/,+1 d' "$CLOUD_INIT_CONFIG"
echo "users: []" >>"$CLOUD_INIT_CONFIG"
