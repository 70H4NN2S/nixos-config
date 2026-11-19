# NixOS workstation

Declarative NixOS development workstation running as a Proxmox VE guest. This repository records the system configuration, not application data or credentials.

## Features

- Pinned Nixpkgs input using a flake and lockfile.
- KDE Plasma, SDDM, PipeWire and German keyboard layout.
- OpenSSH (root login disabled), NixOS firewall and network diagnostics.
- QEMU guest integration, Docker, local-only PostgreSQL.
- Reproducible development toolchains and Zsh.

## Structure

| Path | Responsibility |
| --- | --- |
| `flake.nix` / `flake.lock` | Host entry point and pinned input |
| `hosts/nixos/` | Host identity, locale, boot and generated hardware configuration |
| `modules/desktop.nix` | Desktop, audio, printing |
| `modules/development.nix` | Shell, database and development tools |
| `modules/networking.nix` | NetworkManager and diagnostics |
| `modules/security.nix` | SSH and firewall |
| `modules/virtualization.nix` | Guest integration and containers |
| `docs/deployment.md` | Deployment, verification and rollback |

## Validate

On a Nix-enabled machine:

```sh
nix flake check --no-build
nix build --dry-run .#nixosConfigurations.nixos.config.system.build.toplevel
```

See [deployment and rollback](docs/deployment.md) before applying the configuration. The current hardware file belongs to the original guest; do not copy its filesystem UUIDs to a different machine.

## Status

Personal workstation configuration. The modular refactor is intended to preserve existing settings; CI evaluation and on-guest testing are required before deployment. No claim of production readiness.
