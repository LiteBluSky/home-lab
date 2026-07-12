{ config, pkgs, username, ... }:

let
  # The exact absolute path to your service folder on your machine's storage
  serviceDir = "/home/${username}/.dotfiles/modules/services/wol-python";
in
{
  # Open the API port
  networking.firewall.allowedTCPPorts = [ 8000 ];

  systemd.services.wol-api = {
    description = "Wake on LAN FastAPI Backend";
    after = [ "network.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      
      # Use a safe temporary directory to run the process
      RuntimeDirectory = "wol-api";
      WorkingDirectory = "/run/wol-api";
      
      # Systemd reads the hidden .env directly from your local clone on disk
      EnvironmentFile = "${serviceDir}/.env";

      # Nix copies main.py into the /nix/store securely (Make sure to run 'git add main.py'!)
      ExecStart = let
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          fastapi
          uvicorn
          pydantic
        ]);
      in "${pythonEnv}/bin/fastapi dev ${./main.py} --host 0.0.0.0 --port 8000";

      Restart = "always";
      RestartSec = "5s";
      User = username;
      Group = "users";
    };
  };
}
