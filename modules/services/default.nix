{ config, pkgs, ... }:

{
  imports = [
    ./filebrowser.nix
    ./copyparty.nix
    ./wol-python/wol.nix
    ./couchdb.nix
    ./super-productivity.nix
    ./dufs.nix
    # ./isolated-browser.nix
    # ./desktop-app-3.nix  <-- Want to disable an app? Just comment it out here!
  ];
}
