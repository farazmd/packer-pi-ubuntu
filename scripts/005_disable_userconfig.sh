#!/bin/bash

# If enabled, blocks cloudinit from running through the modules_final stage (systemd service)
systemctl stop userconfig
systemctl disable userconfig
systemctl mask userconfig

