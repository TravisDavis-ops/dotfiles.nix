{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.home-network.proxy;
in
{
  options.local.home-network.proxy = {
    enable = mkEnableOption "enable nginx proxy";
    listen = mkOption { type = types.attrsOf types.anything; };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts.${config.services.grafana.domain} = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
          proxyWebsockets = true;
        };
      };
    };
    services = {
      prometheus = {
        enable = true;
        port = 8084;
      };
      grafana = {
        enable = true;
        domain = "metrics.home";
        port = 8085;
        addr = "127.0.0.1";
      };
    };
  };
}
