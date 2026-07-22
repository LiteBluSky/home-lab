{ config, pkgs, ... }:

{
  services.searx = {
    enable = true;
    package = pkgs.searxng; # Ensures you are using SearXNG instead of legacy Searx
    
    # Point to the secret environment file created in Step 1
    environmentFile = "/var/lib/searxng/secret.env";
    
    # Optionally spin up a local Redis instance for rate-limiting & plugins
    redisCreateLocally = true; 

    settings = {
      server = {
        # Bind locally if you plan to put Nginx/Caddy in front of it (Recommended)
        bind_address = "127.0.0.1";
        port = 8888;
        base_url = "https://nixos.kooka-pence.ts.net"; # Change to your actual domain
        secret_key = "@SEARXNG_SECRET@";        # References the variable in environmentFile
      };
      
      # Customize search defaults or engines if desired
      search = {
        safe_search = 1; # 0: None, 1: Moderate, 2: Strict
      };
    };
  };

  # Optional: Open firewall if binding directly to a public interface 
  # (Skipped if you use a reverse proxy like Nginx/Caddy locally)
  # networking.firewall.allowedTCPPorts = [ 8888 ];
}
