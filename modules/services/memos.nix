{ config, pkgs, ... }:

{
  services.memos = {
    enable = true;
    package = pkgs.memos;
    settings = {
      MEMOS_MODE = "prod";
      MEMOS_ADDR = "0.0.0.0";
      MEMOS_PORT = "5230";
      MEMOS_DATA = config.services.memos.dataDir;
      MEMOS_DRIVER = "sqlite";
      MEMOS_INSTANCE_URL = "http://localhost:5230";
    };
    openFirewall = true;
  };
}
