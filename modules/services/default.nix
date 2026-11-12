# Every service on the server. To turn one off, comment out its line.
# The list of apps with their ports (for the homepage) is in apps.nix.
{ ... }:

{
  # Containers (oci-containers) run with Docker.
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  imports = [
    ./homepage.nix
    ./tailscale.nix

    ./essentials.nix
    ./immich.nix
    ./actual-server.nix
    ./searxng.nix
    ./filebrowser.nix
    ./copyparty.nix
    ./beszel.nix
    ./couchdb.nix
    ./wol-python/wol.nix
  ];
}
