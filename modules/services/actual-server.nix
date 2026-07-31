{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.actual-budget = {
    image = "docker.io/actualbudget/actual-server:latest";
    autoStart = true; # Replaced 'restart = "always"' with this
    ports = [
      "0.0.0.0:5006:5006"
    ];
    volumes = [
      "/var/lib/actual-budget:/data"
    ];
  };

  system.activationScripts.actual-budget-dir = ''
    mkdir -p /var/lib/actual-budget
  '';
}
