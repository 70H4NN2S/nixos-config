# Workstation bootstrap and migration checklist

**Status:** proposal only. The current live `/etc/nixos` files are authoritative until the migration is reviewed.

## Current environment

- NixOS 26.05, KDE Plasma on Wayland, Proxmox VE VM.
- Normal user: `johannes`.
- ext4 root and 4 GiB swap.
- QEMU agent, OpenSSH, Docker, PostgreSQL, Zsh, Flatpak and Sunshine.
- Static addressing is deliberately **not** encoded in this public repository pending confirmation of the network interface, gateway, DNS and address ownership.

## Safe workflow

1. Back up or snapshot the VM in Proxmox.
2. Read the actual `/etc/nixos/configuration.nix`, `hardware-configuration.nix` and `workstation.nix` on the VM.
3. Check these files for passwords, credentials and identifiers you do not want public; do not commit secrets.
4. Avoid importing both a copy of `workstation.nix` and another module declaring overlapping non-mergeable options until you have reconciled them.
5. Do not replace `configuration.nix` or `system.stateVersion` with a generic template.
6. Migrate the reviewed configuration to `hosts/nixos-workstation/` and only then introduce `flake.nix` / `flake.lock` pinned to `nixos-26.05`.
7. Run `sudo nixos-rebuild build --flake .#nixos-workstation` from the repository root before switching, and confirm the generated configuration uses the actual installed disk and bootloader.
8. Keep a working boot generation and Proxmox VM backup for rollback.

## First local changes

To switch the default shell without changing anything else, add this to the *existing* `/etc/nixos/workstation.nix` (inside its top-level attribute set):

```nix
users.users.johannes.shell = pkgs.zsh;
```

Ensure the module has `{ pkgs, ... }:` in its header, that `programs.zsh.enable = true;` exists, and that the user is defined in the installer-generated configuration.

Then run:

```sh
sudo nixos-rebuild build
sudo nixos-rebuild switch
getent passwd johannes
```

Log out and in again to observe the new login shell.

## Sunshine diagnostics

Run these commands **inside the active KDE desktop session**, not in a disconnected SSH session:

```sh
systemctl --user status sunshine -l --no-pager
sudo ss -lntup | grep -E '47989|47990|48010'
curl -vk --connect-timeout 5 https://127.0.0.1:47990/
journalctl --user -u sunshine -b -n 100 --no-pager
ls -l /dev/dri
```

The web UI is **HTTPS on port 47990**; Moonlight's manual host address uses **port 47989**. If the UI works on localhost but cannot be reached from the Mac, check firewall, listening address and routing between the two routers before changing Sunshine settings. SSH tunneling the web UI is a safer alternative to exposing it:

```sh
ssh -L 47990:127.0.0.1:47990 johannes@YOUR_VM_IP
```

Then browse to `https://localhost:47990` on the Mac.

Capture/encoding can still fail even if the web UI works. Without GPU passthrough, inspect the VM display device and Sunshine logs before changing Proxmox video hardware.

## VS Code

The Nixpkgs `vscode` 1.144.0 package has a reported stable-branch build failure (nixpkgs #584492). Postpone the native Nix package until fixed. The community-packaged Flatpak `com.visualstudio.code` works as a GUI editor but its sandbox complicates access to host build tools.

For Mac-first development, use native VS Code on macOS with the Remote - SSH extension, connecting to the NixOS machine. `programs.nix-ld.enable = true` helps with downloaded VS Code server binaries.

## Public repository precautions

Do not commit `~/.ssh`, Sunshine credentials, `/etc/NetworkManager/system-connections`, credentials embedded in Nix files, environment secrets, tokens, or private key material. `.gitignore` is only a partial defense; manually inspect `git diff --cached` before pushing.
