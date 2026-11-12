# Home server

NixOS configuration for the home server (`nixos`, 192.168.0.17).
Homepage with every app: http://192.168.0.17 (LAN) or
https://nixos.kooka-pence.ts.net (Tailscale).

## Layout

```text
flake.nix                    # entry point (pins nixpkgs)
hosts/nixos/                 # this machine: boot, network, users, packages
modules/services/
  default.nix                # which services are on (comment a line to turn one off)
  apps.nix                   # every app with its ports -> homepage + Tailscale https
  homepage.nix               # the homepage (nginx on port 80)
  tailscale.nix              # Tailscale + https ports, generated from apps.nix
  <app>.nix                  # one file per app
```

App data lives in `/var/lib/<app>`; shared files in `~/shared-files`.

## Apply changes

```bash
rebuild          # = git add -A && sudo nixos-rebuild switch --flake ~/.dotfiles
```

Not sure? `sudo nixos-rebuild test --flake ~/.dotfiles` applies it until the
next reboot only. Something broke? Pick the previous generation in the boot
menu, or `sudo nixos-rebuild switch --rollback`.

## Add an app

1. Create `modules/services/<app>.nix` (copy a similar one: a NixOS service
   like `immich.nix`, or a Docker image like `essentials.nix`).
2. Add it to `imports` in `modules/services/default.nix`.
3. Add it to `apps.nix` (name, port, description; `https` for a Tailscale
   https port). Pick a port that's free: `ss -ltn`.
4. `rebuild`, then commit.

## Update

- Everything (NixOS + apps from nixpkgs): `nix flake update --flake ~/.dotfiles`, then `rebuild`.
- A Docker app on `:latest` (e.g. Essentials, which has `pull = "always"`):
  `sudo systemctl restart docker-essentials`.

## Your user's tools (Home Manager)

Separate from this repo, in `~/.config/home-manager` (managed by chezmoi):

```bash
home-manager switch --flake ~/.config/home-manager
```
