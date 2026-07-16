{ pkgs, ... }:

{
  services.couchdb = {
    enable = true;
    package = pkgs.couchdb3;
    # CouchDB binds to localhost by default; change to "0.0.0.0" to expose it to your home network
    bindAddress = "0.0.0.0"; 
  };

  # 2. Open the port in your firewall (CouchDB default port is 5984)
  networking.firewall.allowedTCPPorts = [ 5984 ];
}
