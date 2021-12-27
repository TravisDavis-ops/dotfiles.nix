{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.anime-hub.containers.komga;
  containerCfg = config.local.anime-hub.containers;
  proxyCfg = config.local.anime-hub.proxy;
  self = {
    interfacePort = 8080;
    configFolder = "/config";
  };
in
with builtins; {
  options.local.anime-hub.containers.komga = {
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
    services.nginx.virtualHosts.${cfg.domainName} = mkIf proxyCfg.enable {
      listen = [ proxyCfg.listen { addr = proxyCfg.listen.addr; port = 81; } ];
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.hostPort}";
      };
    };
  };
}
