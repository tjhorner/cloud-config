#!/bin/sh
sudo nix-channel --add https://nixos.org/channels/nixos-21.11 nixos
sudo nixos-rebuild switch --upgrade
