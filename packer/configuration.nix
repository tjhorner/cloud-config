{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
  ];

  # Modify the startup script service to allow access to various
  # tools so that it can bootstrap a Nix config from somewhere else
  systemd.services.google-startup-scripts.environment = config.nix.envVars // {
    inherit (config.environment.sessionVariables) NIX_PATH;
    HOME = "/root";
  } // config.networking.proxy.envVars;

  # The service would restart itself if the NixOS config is rebuilt
  # and something changed about it, so we don't want to do that
  systemd.services.google-startup-scripts.restartIfChanged = false;
  systemd.services.google-startup-scripts.stopIfChanged = false;

  # We need to run the startup script after other services have started
  systemd.services.google-startup-scripts.after = [ "multi-user.target" ];

  systemd.services.google-startup-scripts.path = with pkgs; [
    git
    bash
    nix
    nixos-rebuild
  ];
}