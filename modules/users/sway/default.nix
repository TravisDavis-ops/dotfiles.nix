{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.sway;
in {
  options.local.sway = {
    enable = mkEnableOption "User Configuration for Sway";
  };
  config = mkIf cfg.enable {
    xdg.configFile."sway/config" = {
      text = ''
        include /etc/sway/config
        output * bg $HOME/.wallpaper fill
        exec pulseaudio
        exec systemctl --user start bar-starter
        exec systemctl --user start notification-starter
      '';
    };
  };
}

