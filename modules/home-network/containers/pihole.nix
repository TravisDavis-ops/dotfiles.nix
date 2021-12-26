{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.home-network.containers.pihole;
  containerCfg = config.local.home-network.containers;
  proxyCfg = config.local.home-network.proxy;
  self = {
    configFolder = "/etc/pihole";
    interfacePort = 80;
    environment = { TZ = "America/Chicago"; };
    requiredPorts = [ "53:53" ];
  };
in
with builtins; {
  options.local.home-network.containers.pihole = {
    enable = mkEnableOption "Activate Pi-Hole Dns";
    domainName = mkOption { type = types.str; };
    hostPort = mkOption { type = types.port; };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."${cfg.domainName}-pihole" = {
      image = "pihole/pihole:latest";
      environment = {
        ServerIp = "${proxyCfg.listen.addr}";
      } // self.environment;
      ports = [
        "${toString cfg.hostPort}:${toString self.interfacePort}"
      ] ++ self.requiredPorts;
      volumes = [
        "pihole:${self.configFolder}:rw"
      ];
      autoStart = true;
    };
    services.nginx.virtualHosts.${cfg.domainName} = mkIf proxyCfg.enable {
      listen = [ proxyCfg.listen ];
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.hostPort}";
      };
    };

  };
}
