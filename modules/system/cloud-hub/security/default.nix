{ config, pkgs, lib, ... }:
with lib;
let cfg = config.os.p.anime-hub.security;
in
{
  options.os.p.anime-hub.security = {
    enable = mkEnableOption "enable the security needs of anime-hub";
    enableDebug = mkEnableOption "allows passwords login and connections on local ports";
  };
  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPortRanges = mkIf cfg.enableDebug [{ from = 8000; to = 9999; }]; # Allow access for debuging
      allowedTCPPorts = [ 80 443 4815 ]; # http https and ssh
    };
    services.openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = cfg.enableDebug;
      listenAddresses = [
        { addr = "0.0.0.0"; port = 4815; } # allow external connection on private port
        { addr = "127.0.0.1"; port = 22; }
      ];
    };
  };
}
