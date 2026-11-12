{ config, pkgs, username, ... }:

{
  # Open the default Immich HTTP port on the host firewall
  networking.firewall.allowedTCPPorts = [ 2283 ];

  # Native NixOS Immich Service
  services.immich = {
    enable = true;
    port = 2283;
    host = "0.0.0.0";

    # Store uploaded photos in your user's home directory
    mediaLocation = "/var/lib/immich-storage";

    # Enable integrated services
    machine-learning.enable = true;
    database.enable = true;
    redis.enable = true;
  };

  # Ensure the target directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/immich-storage 0750 immich immich -"
  ];
}
