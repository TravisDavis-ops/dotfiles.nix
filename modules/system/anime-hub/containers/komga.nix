{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.os.p.anime-hub.containers.komga;
  containerCfg = config.os.p.anime-hub.containers;
  serverCfg = config.os.p.anime-hub.server;
  self = {
    interfacePort = 8080;
    configFolder = "/config";
  };
in
with builtins; {
  options.os.p.anime-hub.containers.komga = {
    enable = mkEnableOption "Activate Komga";
    domainName = mkOption { type = types.str; };
    hostPort = mkOption { type = types.port; };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."${cfg.domainName}-komga" = {
      image = "gotson/komga:latest";
      ports = [ "${toString cfg.hostPort}:${toString self.interfacePort}" ];
      volumes = [
        "komga:${self.configFolder}"
        "${containerCfg.mediaFolder}:/media"
      ];
      autoStart = true;
    };
    services.nginx.virtualHosts.${cfg.domainName} = mkIf serverCfg.enable {
      listen = [ serverCfg.bond { addr = serverCfg.bond.addr; port = 81; } ];
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.hostPort}";
      };
    };
  };
}
