{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.openssh;
in
{
  options.local.openssh = {
    enable = mkEnableOption "Enable openssh daemon";
  };
  config = mkIf cfg.enable {
    services.openssh = {
        enable = true;
        ports = [ 4815 ];
    };
  };
}
