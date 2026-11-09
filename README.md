# NixOS workstation configuration

Declarative configuration for a NixOS 26.05 KDE Plasma workstation running on Proxmox VE.

## Status

**Bootstrap in progress.** The live VM configuration is still the source of truth. Do not run a Flake rebuild from this repository until the existing `/etc/nixos/configuration.nix` and `hardware-configuration.nix` have been reviewed and migrated.

Planned: Nix Flakes, Home Manager, development tools, Zsh, SSH, Sunshine/Moonlight and reproducible VS Code preferences.

## Safety

This repository is public. Never commit credentials, SSH private keys, tokens, Sunshine authentication data, private network connection profiles, database passwords, or secrets.

Configuration changes should be proposed via pull requests and tested locally with `nixos-rebuild build` before switching.

## References

- [Official NixOS manual](https://nixos.org/manual/nixos/stable/)
- [Official NixOS wiki](https://wiki.nixos.org/)
