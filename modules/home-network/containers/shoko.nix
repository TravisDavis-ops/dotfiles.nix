{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.home-network.containers.shoko;
  containerCfg = config.local.home-network.containers;
  proxyCfg = config.local.home-network.proxy;
  self = {
    configFolder = "/home/shoko/.shoko";
    interfacePort = 8111;
    environment = { TZ = "America/Chicago"; AVDUMP_MONO = "true"; };
  };
in
with builtins; {
  options.local.home-network.containers.shoko = {
    enable = mkEnableOption "Activate Shoko Server";
    domainName = mkOption { type = types.str; };
    hostPort = mkOption { type = types.port; };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."${cfg.domainName}-shoko" = {
      image = "shokoanime/server:latest";
      environment = self.environment;
      ports = [
        "${toString cfg.hostPort}:${toString self.interfacePort}"
      ];
      volumes = [
        "shoko:${self.configFolder}:rw"
        "${containerCfg.mediaFolder}:/media/"
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
