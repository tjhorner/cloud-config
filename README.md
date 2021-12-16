# cloud-config

> ⚠️ This is a work in progress. Please don't use this in production. Or anywhere.

This repository contains all the configuration necessary to provision and configure all the infrastructure for my personal cloud on GCP. It's where I host things like my blog, Telegram bots, and various other things.

## Overview

At a high level, these components work together to provision and configure all the necessary resources:

- [Packer](https://www.packer.io): Builds the NixOS images that the GCE VMs run
- [Terraform](https://terraform.io): Provisions GCP resources
  - GCE VMs: These run Nomad and Consul
  - GCE Network and Firewall: For allowing certain inbound communications for web traffic
- [Nomad](https://www.nomadproject.io): Runs all the workloads
- [NixOS](https://nixos.org): Manages OS state and service configuration

## Technical Details

### NixOS Configuration

The NixOS image is built with a special initial configuration which allows the GCE startup script to bootstrap a NixOS configuration from somewhere else. In my case, the startup script looks like this:

```bash
#!/bin/sh
[ -d "/etc/nixos/.git" ] && exit 0

rm -rf /etc/nixos

git clone https://github.com/tjhorner/cloud-nixos-config.git /etc/nixos
ln -s /etc/nixos/${nixos_config}/configuration.nix /etc/nixos/configuration.nix

nixos-rebuild switch
```

This will remove the existing NixOS configuration and replace it with the contents of [this repo](https://github.com/tjhorner/cloud-nixos-config), which contains a few config variants. At the moment there are variants for `consul-server` and `nomad-server`.

- `consul-server`: Runs a Consul server and sets the `bootstrap_expect` based off the VM metadata
- `nomad-server`: Runs a Nomad server **and client** on the same VM (this is not best practice, but it costs a lot otherwise lol). Also runs a Consul client which connects to the Consul server cluster

Terraform will interpolate the correct `nixos_config` based on the instance it is creating.

The configuration also provides a systemd service/timer to periodically pull the latest NixOS configuration from the repo and switch to it.

### Nomad Configuration

The Nomad agents are configured to automatically discover other Nomad agents in the cluster via VM tags -- each instance that is running a Nomad server will have the tag `nomad-server`, so the Nomad configuration has `retry_join` set to `provider=gce tag_value=nomad-server` accordingly.

Each instance that runs a Nomad server also runs a Nomad client because I am lazy and don't want to spend too much money. Docker is also installed on each agent so they can run containerized workloads (which most of my things are).