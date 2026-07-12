{ config, pkgs, username, ... }:

{
  # Open the port on the host firewall
  networking.firewall.allowedTCPPorts = [ 3923 ];

  # Native Copyparty Service running on startup via Systemd
  systemd.services.copyparty = {
    description = "Copyparty File Server (Native Host)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      ExecStart = "${pkgs.copyparty}/bin/copyparty -v /home/${username}/shared-files::rw";
      Restart = "always";
      User = username;
    };
  };
}
