{ config, pkgs, lib, ... }:
with lib;
let cfg = config.os.p.openssh;
in
{
  options.os.p.openssh = {
    enable = mkEnableOption "Enable openssh daemon";
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      permitRootLogin = "no";
      ports = [ 4815 ];
    };
  };
}
