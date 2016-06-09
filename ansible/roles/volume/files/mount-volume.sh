#!/bin/bash

# Wait for volume to be attached
while [ ! -e /dev/vdb ]; do
  sleep 10
done

# Mounting attached volume
mkfs.ext4 /dev/vdb
mkdir /mnt/volume
mount /dev/vdb /mnt/volume
chown -R ubuntu /mnt/volume
