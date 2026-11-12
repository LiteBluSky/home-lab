{ config, pkgs, username, ... }:
{
  virtualisation.oci-containers.containers.essentials = {
    image = "ghcr.io/liteblusky/essentials:latest";
    # Pull on every (re)start so a new release is picked up.
    pull = "always";
    # LAN + localhost only, so Tailscale can serve https on 8008 too.
    ports = [ "127.0.0.1:8008:8008" "192.168.0.17:8008:8008" ];
    volumes = [ "/var/lib/essentials:/data" ];
    # Only if the image on GHCR is private:
    # login = {
    #   registry = "ghcr.io";
    #   username = "<github-user>";
    #   passwordFile = "/run/secrets/ghcr-token"; # a PAT with read:packages
    # };
  };

  # The container runs as the image's `node` user (uid 1000).
  systemd.tmpfiles.rules = [ "d /var/lib/essentials 0750 1000 1000 -" ];

  # Reach it from other devices on the LAN (Tailscale https: see apps.nix).
  networking.firewall.allowedTCPPorts = [ 8008 ];
}
