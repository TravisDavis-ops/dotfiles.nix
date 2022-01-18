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
  options.os.p.anime-hub = {
    enable = mkEnableOption "anime-hub";
  };
  config.os.p = mkIf cfg.enable {
    anime-hub = {
      security.enable = true;

      metrics = {
        enable = false;
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
        ################################################################################
        # Manage Containers
        komga = {
          enable = true;
          domainName = "ruby.library";
          hostPort = 8081;
        };
        ################################################################################
        # Anime Containers disabled do issues on ruby
        # jellyfin = {
        #   enable = false; # occasional gpu crash while decodeing
        #   domainName = "ruby.media";
        #   hostPort = 8082;
        # };

        # shoko = {
        #   # need shokofin to be installed in order to use metadata collected in jellyfin
        #   enable = false; # long shutdown if at all
        #   domainName = "ruby.metadata";
        #   hostPort = 8083;
        # };
      };
    };
  };
}
