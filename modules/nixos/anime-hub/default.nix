{ pkgs, config, lib, ... }:
let
  cfg = config.os.p.anime-hub;
in
with lib; {

  imports = [
    ./server.nix
    ./security
    ./metrics
    ./containers
  ];
  options.os.p.anime-hub= {
    enable = mkEnableOption "anime-hub";
  };
  config.os.p = mkIf cfg.enable {
    anime-hub = {
      security.enable = true;
      metrics = {
        enable = true;
        domainName = "ruby.dashboard";
        collectorPort = 9002;
        managementPort = 9001;
        dashboardPort = 9000;
      };

      server = {
        enable = true;
        bond = { addr = "192.168.1.64"; port = 80; };
      };

      containers = {
        mediaFolder = "/mnt";
        #portRange = range 8000 9000;
        pihole = {
          enable = true;
          domainName = "ruby.admin";
          hostPort = 8080;
        };
        komga = {
          enable = true;
          domainName = "ruby.library";
          hostPort = 8081;
        };
        jellyfin = {
          enable = true;
          domainName = "ruby.media";
          hostPort = 8082;
        };
        shoko = {
          enable = true;
          domainName = "ruby.metadata";
          hostPort = 8083;
        };
      };
    };
  };
}
