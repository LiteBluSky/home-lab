# Every app on this server, in one list. The homepage (homepage.nix) and the
# Tailscale https ports (tailscale.nix) are generated from it.
# Changing an app's port? Change it here AND in the app's own .nix file.
#
#   port  = where the app listens on the server: http://192.168.0.17:<port>
#   https = the port Tailscale serves it on with https:
#           https://nixos.kooka-pence.ts.net:<https> (leave out = none)
#   lan   = false if the app only listens on the server itself (no LAN link)
#   path  = added to the links, e.g. "/docs" (optional)
{
  lanIp = "192.168.0.17";
  tailnetHost = "nixos.kooka-pence.ts.net";

  apps = [
    { name = "Essentials";         port = 8008;  https = 8008; description = "Bookmarks, notes, tasks and contacts"; }
    { name = "Immich";             port = 2283;  https = 9445; description = "Photos and videos"; }
    { name = "Actual Budget";      port = 5006;  https = 9443; description = "Budgeting"; }
    { name = "SearXNG";            port = 8888;  https = 8443; lan = false; description = "Private web search"; }
    { name = "File Browser";       port = 8081;  description = "Browse ~/shared-files"; }
    { name = "Copyparty";          port = 3923;  description = "File sharing (FTP on port 3921)"; }
    { name = "Beszel";             port = 8090;  description = "Server monitoring"; }
    { name = "CouchDB";            port = 5984;  path = "/_utils"; description = "Database (Fauxton admin)"; }
    { name = "Wake on LAN";        port = 8000;  path = "/docs"; description = "Wake-on-LAN API"; }
  ];
}
