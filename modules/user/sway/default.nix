{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.sway;
  lock-cmd = pkgs.writeShellScriptBin "lock" ''
    swaylock --screenshots \
       --clock \
       --indicator \
       --datestr "%m-%d" \
       --effect-blur 7x5 \
       --ring-color 9AA5CE \
       --key-hl-color 9ECE6A \
       --text-color 7DCFFF \
       --line-color 00000000 \
       --inside-color 00000088 \
       --separator-color 00000000 \
       --fade-in 0.2 \
  '';
in
{
  options.local.sway = {
    enable = mkEnableOption "User Configuration for Sway";
  };
  config = mkIf cfg.enable {
    home.packages = [ lock-cmd ];
    xdg.configFile."sway/config".source = ./config.sway;
  };
}

