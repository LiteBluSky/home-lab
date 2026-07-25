{ pkgs, username, ... }:
let
  # The exact absolute path to your service folder on your machine's storage
  serviceDir = "/home/${username}/.dotfiles/modules/services";
in
{
  services.beszel.hub = {
    enable = true;
    port = 8090;
    host = "0.0.0.0";
  };
  services.beszel.agent = {
    enable = true;
    openFirewall = true;
    smartmon.enable = true;
  }; 

  systemd.services.beszel-agent.serviceConfig.EnvironmentFile = [
    "${serviceDir}/.env"
  ];

  # Open the ports in your firewall (Beszel Hub port 8090, Agent port 45876)
  networking.firewall.allowedTCPPorts = [ 8090 45876 ];
}
