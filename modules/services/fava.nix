{ config, pkgs, username, ... }:

{
  # 1. Open the port for Fava (default is 5000)
  networking.firewall.allowedTCPPorts = [ 5000 ];

  # 2. Define the Fava Systemd Service
  systemd.services.fava = {
    description = "Fava (Beancount Web Interface)";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target"];

    serviceConfig = {
      # -H 0.0.0.0 allows access from other devices on your network
      # If you only want to access it locally on the host, omit -H or use 127.0.0.1
      ExecStart = "${pkgs.fava}/bin/fava -H 0.0.0.0 /home/${username}/finance/main.beancount";
      Restart = "always";
      User = username;
    };
  };
}
