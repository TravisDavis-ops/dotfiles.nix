{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.wofi;

in
{
  options.local.wofi = { enable = mkEnableOption "wofi-themeing"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ wofi ];
    xdg.configFile."wofi/config".source = ./config;
    xdg.configFile."wofi/style.css".source = ./style.css;
  };
}
