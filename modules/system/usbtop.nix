{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.usbtop;
in
{
  options.local.usbtop = {
    enable = mkEnableOption "Enable Usbtools";
  };
  config = mkIf cfg.enable {
    programs.usbtop = { enable = true; };
  };
}
