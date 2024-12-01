#!/bin/bash

# Suspend needrestart for packer not to hang
export NEEDRESTART_SUSPEND=true
export DEBIAN_FRONTEND=noninteractive

# Custom base directory
export BASE_DIR="/${BASE_DIR_NAME}"

apt-get update &&
  apt-get install --no-install-recommends -y \
    cloud-init \
    curl \
    openssh-server \
    python3-venv

rm -rf /var/cache/apt/*

# go
echo "Installing go v1.22"
curl -o /tmp/go1.22.4.linux-arm64.tar.gz -LJ https://go.dev/dl/go1.22.4.linux-arm64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go1.22.4.linux-arm64.tar.gz
rm -rf /tmp/go1.22.4.linux-arm64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >>/etc/profile
echo "Done installing go v1.22"

# nvm
export NVM_DIR=/usr/local/nvm
mkdir -p ${NVM_DIR}
echo "export NVM_DIR=${NVM_DIR}" >>/etc/profile
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >>/etc/profile

# yq
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_arm64 -O /usr/bin/yq &&
  chmod +x /usr/bin/yq

rm -rf /var/cache/apt/*

#Python venv
python3 -m venv "${BASE_DIR}/tools/pyenv"

source "${BASE_DIR}/tools/pyenv/bin/activate"

python -m pip install ansible==11.0.0

python -m pip cache purge
