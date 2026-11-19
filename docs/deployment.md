# Deployment and rollback

## Existing guest

1. Confirm console access via Proxmox and take a snapshot if appropriate. Back up important data independently.
2. Review the diff and confirm that the host and hardware configuration match this guest.
3. From the repository root, evaluate and build before switching.

```sh
nix flake check --no-build
sudo nixos-rebuild build --flake .#nixos
sudo nixos-rebuild test --flake .#nixos
```

Verify login, network connectivity, SSH from a trusted client, firewall, KDE, audio, QEMU agent, Docker and local PostgreSQL. Then persist the tested configuration:

```sh
sudo nixos-rebuild switch --flake .#nixos
```

Keep console access until remote access has been verified. Check services with `systemctl --failed` and `journalctl -b -p warning`. Docker access may require sudo; membership of the Docker group grants powerful host access.

## New guest

Generate the hardware configuration on the target and replace the existing host-specific file in a local working copy. Adapt username, locale and host identity. Preserve the installed system's stateVersion; do not increase it merely to upgrade packages. Do not publish credentials, private keys or actual sensitive host inventory.

## Rollback

Use `sudo nixos-rebuild switch --rollback` or select the prior generation from the boot menu if the system fails to boot. A VM snapshot is a separate recovery mechanism, not a substitute for backups.

## Scope

The flake pins the package set. The CI check evaluates the NixOS configuration but does not prove the desktop or hardware works on a real guest.
