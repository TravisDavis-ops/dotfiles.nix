{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.os.p.anime-hub.containers.pihole;
  containerCfg = config.os.p.anime-hub.containers;
  serverCfg = config.os.p.anime-hub.server;
  self = {
    configFolder = "/etc/pihole";
    interfacePort = 80;
    environment = { TZ = "America/Chicago"; };
    requiredPorts = [ "53:53" ];
  };
in
with builtins; {
  options.os.p.anime-hub.containers.pihole = {
    enable = mkEnableOption "Activate Pi-Hole Dns";
    domainName = mkOption { type = types.str; };
    hostPort = mkOption { type = types.port; };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."${cfg.domainName}-pihole" = {
      image = "pihole/pihole:latest";
      environment = {
        ServerIp = "${serverCfg.bond.addr}";
      } // self.environment;
      ports = [
        "${toString cfg.hostPort}:${toString self.interfacePort}"
      ] ++ self.requiredPorts;
      volumes = [
        "pihole:${self.configFolder}:rw"
      ];
      autoStart = true;
    };
    services.nginx.virtualHosts.${cfg.domainName} = mkIf serverCfg.enable {
      listen = [ serverCfg.bond ];
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.hostPort}";
      };
    };

  };
}
