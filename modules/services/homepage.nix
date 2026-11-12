# The homepage: one HTML page listing every app in apps.nix with its links.
# http://192.168.0.17 on the LAN, https://nixos.kooka-pence.ts.net on Tailscale.
{ pkgs, ... }:
let
  inherit (import ./apps.nix) lanIp tailnetHost apps;

  link = url: label: ''<a href="${url}">${label}</a>'';

  row = app:
    let
      port = toString app.port;
      path = app.path or "";
      onLan = app.lan or true;
      https = app.https or null;
      lan = if onLan then link "http://${lanIp}:${port}${path}" ":${port}" else "<span>server only</span>";
      tailscale =
        if https != null then link "https://${tailnetHost}:${toString https}${path}" "https :${toString https}"
        else if onLan then link "http://${tailnetHost}:${port}${path}" "http :${port}"
        else "";
    in ''
      <tr><td><b>${app.name}</b><small>${app.description}</small></td><td>${lan}</td><td>${tailscale}</td></tr>
    '';

  page = pkgs.writeTextDir "index.html" ''
    <!doctype html>
    <html lang="en">
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Home server</title>
    <style>
      :root { color-scheme: light dark; --muted: #6b7280; --line: #e5e7eb; --link: #2563eb; }
      @media (prefers-color-scheme: dark) { :root { --muted: #9ca3af; --line: #2a2a2e; --link: #7aa2ff; } }
      body { font: 15px/1.5 system-ui, sans-serif; max-width: 46rem; margin: 2.5rem auto; padding: 0 1rem; }
      h1 { font-size: 1.4rem; margin: 0 0 .25rem; }
      p { color: var(--muted); margin: 0 0 1.5rem; }
      table { width: 100%; border-collapse: collapse; }
      th { text-align: left; font-weight: 500; color: var(--muted); font-size: .8rem; }
      th, td { padding: .6rem .5rem; border-bottom: 1px solid var(--line); vertical-align: top; }
      small { display: block; color: var(--muted); }
      a { color: var(--link); text-decoration: none; white-space: nowrap; }
      a:hover { text-decoration: underline; }
      span { color: var(--muted); }
    </style>
    </head>
    <body>
    <h1>Home server</h1>
    <p>LAN: ${lanIp} · Tailscale: ${tailnetHost}</p>
    <table>
    <tr><th>App</th><th>LAN</th><th>Tailscale</th></tr>
    ${builtins.concatStringsSep "" (map row apps)}
    </table>
    </body>
    </html>
  '';
in
{
  services.nginx = {
    enable = true;
    virtualHosts.homepage = {
      default = true;
      listen = [ { addr = "0.0.0.0"; port = 80; } ];
      root = page;
    };
  };
}
