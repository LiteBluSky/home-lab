# Homeserver Configuration

A NixOS-based homeserver configuration utilizing Nix Flakes.

---

## 📂 Repository Structure

- `hosts/desktop/` — Host-specific configuration for the primary system.
- `modules/services/` — Reusable modules for deploying various homeserver services.
- `flake.nix` & `flake.lock` — Core Nix Flake configuration and pinned dependency versions.

---

# 🚀 Getting Started / Installation

> **⚠️ Warning**
>
> Before applying this configuration to a machine, review the hardware configuration and settings inside `hosts/desktop/` to ensure compatibility.

## 1. Clone the Repository

Clone the repository and enter the project directory:

```bash
git clone git@github.com:LiteBluSky/homeserver.git ~/.dotfiles
cd ~/.dotfiles
```

## 2. Verify the Flake

Validate the flake and ensure all outputs evaluate correctly:

```bash
nix flake check
```

## 3. Deploy / Rebuild the Configuration

### Test the configuration

Test the configuration without making it the default boot configuration:

```bash
sudo nixos-rebuild test --flake .#desktop
```

### Apply the configuration permanently

Build, activate, and make the configuration persistent:

```bash
sudo nixos-rebuild switch --flake .#desktop
```

---

# 🛠️ Managing Services

New homeserver services should be created inside:

```text
modules/services/
```

Then import the module into your host configuration under:

```text
hosts/desktop/
```

### After Making Changes

If you've added new files, remember to stage them before rebuilding. Nix Flakes only include files tracked by Git.

```bash
git add .
sudo nixos-rebuild switch --flake .#desktop
```

---

# 📌 Notes

- Keep `flake.lock` committed to ensure reproducible builds.
- Run `nix flake check` before switching configurations whenever possible.
- Review hardware-specific settings before deploying to a different machine.
