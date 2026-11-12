# Tailscale, plus https on the tailnet for every app in apps.nix that has an
# `https` port, and the homepage on https://nixos.kooka-pence.ts.net.
# An app whose https port is the same as its own port must not listen on
# 0.0.0.0, or the two clash (see essentials.nix).
{ pkgs, lib, ... }:
let
  inherit (import ./apps.nix) apps;
  tailscale = "${pkgs.tailscale}/bin/tailscale";
  served = builtins.filter (app: (app.https or null) != null) apps;
  serve = app:
    "${tailscale} serve --bg --https=${toString app.https} http://127.0.0.1:${toString app.port}  # ${app.name}";
in
{
  services.tailscale.enable = true;

  systemd.services.tailscale-serve = {
    description = "Configure Tailscale Serve ports";
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "tailscaled.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "tailscale-serve" ''
        set -e
        ${tailscale} serve reset
        ${tailscale} serve --bg --https=443 http://127.0.0.1:80  # homepage
        ${lib.concatMapStringsSep "\n" serve served}
      '';
    };
  };
}
