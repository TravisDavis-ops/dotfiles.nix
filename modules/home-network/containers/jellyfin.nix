{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.home-network.containers.jellyfin;
  containerCfg = config.local.home-network.containers;
  proxyCfg = config.local.home-network.proxy;
  self = {
    interfacePort = 8096;
    configFolder = "/config";
    cacheFolder = "/cache";
  };
in
with builtins; {
  options.local.home-network.containers.jellyfin = {
    enable = mkEnableOption "Activate Jellyfin";
    domainName = mkOption { type = types.str; };
    hostPort = mkOption { type = types.port; };
  };
  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."${cfg.domainName}-jellyfin" = {
      image = "jellyfin/jellyfin:latest";
      #cmd = ["--device /dev/dri/card1:/dev/dri/card1"  "--device /dev/dri/renderD129:/dev/dri/renderD129" "--device /dev/dri/renderD128:/dev/dri/renderD128" "--device /dev/dri/card0:/dev/dri/card0"];
      environment = {
        #JELLYFIN_PublishedServerUrl="http://${cfg.domainName}";
      };
      ports = [
        "${toString cfg.hostPort}:${toString self.interfacePort}"
      ];
      volumes = [
        "jellyfin:${self.configFolder}:rw"
        "jellyfin-cache:${self.cacheFolder}:rw"
        "${containerCfg.mediaFolder}:/media"
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
