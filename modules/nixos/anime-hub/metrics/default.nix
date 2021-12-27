{ config, pkgs, lib, ... }:
with lib;
let cfg = config.os.p.anime-hub.metrics;
in
{
  options.os.p.anime-hub.metrics = with types; {
    enable = mkEnableOption "configure anime-hub's metrics dashboard";
    domainName = mkOption{ type= str; };
    collectorPort = mkOption{ type=port; };
    managementPort = mkOption{ type=port; };
    dashboardPort = mkOption{ type=port; };
  };

  config = mkIf cfg.enable {
    services = {
      nginx = {
        virtualHosts.${cfg.domainName} = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.dashboardPort}";
            proxyWebsockets = true;
          };
          locations."/collector" = {
            proxyPass = "http://127.0.0.1:${toString cfg.managementPort}";
            proxyWebsockets = true;
          };
        };
      };
      prometheus = {
        enable = true;
        port = cfg.managementPort;
        exporters = {
          node = {
            enable = true;
            enabledCollectors = [ "systemd" "cpu" "cpufreq" "diskstats" "hwmon" "filesystem" "mdadm" "netdev"];
            port = cfg.collectorPort;
          };
        };
        scrapeConfigs = [
          {
            job_name = "${cfg.domainName}";
            static_configs = [{
              targets = [
                "127.0.0.1:${toString cfg.collectorPort}"
              ];
            }];
          }
        ];
      };
      grafana = {
        enable = true;
        domain = cfg.domainName;
        port = cfg.dashboardPort;
        addr = "127.0.0.1";
      };
    };
  };
}
