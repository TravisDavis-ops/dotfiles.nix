{ pkgs, config, lib, ... }:
let
  cfg = config.local.home-network;
in
with lib; {
  imports = [
    ./containers
    ./proxy
    ./security
  ];
  options.local.home-network = {
    enable = mkEnableOption "home-network";
  };
  config = mkIf cfg.enable {
    local.home-network = {
      security.enable = true;

      proxy = {
        enable = true;
        listen = { addr = "192.168.1.64"; port = 80; };
      };

      containers = {
        mediaFolder = "/mnt";

        pihole = {
          enable = true;
          domainName = "www.admin.home";
          hostPort = 8080;
        };
        komga = {
          enable = true;
          domainName = "www.library.home";
          hostPort = 8081;
        };
        jellyfin = {
          enable = true;
          domainName = "www.media.home";
          hostPort = 8082;
        };
        shoko = {
          enable = true;
          domainName = "www.meta.home";
          hostPort = 8083;
        };
      };
    };
  };
}
