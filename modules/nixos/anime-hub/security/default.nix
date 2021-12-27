{ config, pkgs, lib, ... }:
with lib;
let cfg = config.os.p.anime-hub.security;
in
{
  options.os.p.anime-hub.security = {
    enable = mkEnableOption "Enable openssh daemon";
  };
  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPortRanges = [{ from = 8000; to = 9999; }];
      allowedTCPPorts = [ 80 4815 53 ];
      allowedUDPPorts = [ 80 4815 53 ];
    };
    services.openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
      listenAddresses = [
        { addr = "192.168.1.64"; port = 4815; }
        { addr = "127.0.0.1"; port = 22; }
      ];
    };
  };
}
