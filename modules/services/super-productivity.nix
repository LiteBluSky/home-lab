{ config, pkgs, ... }:

{
  virtualisation.oci-containers.backend = "docker";
  
  virtualisation.oci-containers.containers.super-productivity = {
    image = "johannesjo/super-productivity:latest";
    ports = [ "11500:80" ];
    autoStart = true;
  };

  # Open the port in your firewall if needed
  networking.firewall.allowedTCPPorts = [ 11500 ];
}
