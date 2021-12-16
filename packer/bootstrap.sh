rm /etc/nixos/configuration.nix
mv /tmp/initial-configuration.nix /etc/nixos/configuration.nix
nix-channel --add https://nixos.org/channels/nixos-21.11 nixos
nixos-rebuild switch --upgrade
