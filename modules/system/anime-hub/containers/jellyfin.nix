{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.os.p.anime-hub.containers.jellyfin;
  containerCfg = config.os.p.anime-hub.containers;
  serverCfg = config.os.p.anime-hub.server;
  self = {
    interfacePort = 8096;
    configFolder = "/config";
    cacheFolder = "/cache";
  };
in
with builtins; {
  options.os.p.anime-hub.containers.jellyfin = {
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
    services.nginx.virtualHosts.${cfg.domainName} = mkIf serverCfg.enable {
      listen = [ serverCfg.bond ];
      locations."/" = {
        proxyPass = "http://localhost:${toString cfg.hostPort}";
      };
    };
  };
}
