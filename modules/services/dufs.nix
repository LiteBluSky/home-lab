{ pkgs, ... }:

{
  # Install the dufs package system-wide
  environment.systemPackages = [ pkgs.dufs ];

  # Create a dedicated systemd service for dufs
  systemd.services.dufs = {
    description = "Dufs File and WebDAV Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "dufs";
      ExecStart = ''
        ${pkgs.dufs}/bin/dufs /var/lib/dufs \
          --bind 0.0.0.0 \
          --port 5030 \
          -A \
          -a myuser:mypassword@/:rw
      '';
      Restart = "always";
    };
  };
  # Open port 5030 in your firewall for Tailscale access
  networking.firewall.allowedTCPPorts = [ 5030 ];
}
