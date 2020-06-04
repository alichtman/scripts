#!/usr/bin/env bash

# Mounts all VMware shares registered for the VM in Settings > Options > Shared Folders at /home/kali/shares

sudo /usr/bin/vmhgfs-fuse .host:/ /home/kali/shares -o subtype=vmhgfs-fuse,allow_other
