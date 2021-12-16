#!/bin/sh
[ -d "/etc/nixos/.git" ] && exit 0

rm -rf /etc/nixos
git clone https://github.com/tjhorner/cloud-nixos-config.git /etc/nixos
nixos-rebuild switch