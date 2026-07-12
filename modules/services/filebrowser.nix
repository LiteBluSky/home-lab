{ config, pkgs, username, ... }:

{
  # Open the port on the host firewall
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Native Filebrowser Service
  services.filebrowser = {
    enable = true;
    user = username;
    group = "users";
    settings = {
      address = "0.0.0.0"; # Listens on all interfaces, including Tailscale
      port = 8080;
      root = "/home/${username}/shared-files";
      # noauth = true;
    };
  };
}
