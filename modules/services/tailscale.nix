{ config, pkgs, ... }: {
  services.tailscale.enable = true;

  # Create a systemd service to configure tailscale serve ports automatically
  systemd.services.tailscale-serve = {
    description = "Configure Tailscale Serve ports";
    after = [ "tailscaled.service" "network-online.target" ];
    wants = [ "tailscaled.service" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "ts-serve-config" ''
        # 1. Reset existing configuration to avoid residual state
        ${pkgs.tailscale}/bin/tailscale serve reset

        # 2. Map SearXNG (local port 8888) to HTTPS port 8443
        ${pkgs.tailscale}/bin/tailscale serve --bg --https=8443 http://127.0.0.1:8888

        # 3. Map Actual Budget (local port 5006) to HTTPS port 9443
        ${pkgs.tailscale}/bin/tailscale serve --bg --https=9443 http://127.0.0.1:5006
      '';
    };
  };
}
