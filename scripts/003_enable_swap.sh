#!/bin/bash

sed -i -e 's/$/ zswap.enabled=1/' /boot/firmware/cmdline.txt
