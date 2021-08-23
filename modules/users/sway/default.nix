{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.sway;
  helpers = import ./helpers.nix;
in
with helpers; {
  options.local.sway = {
    enable = mkEnableOption "User Configuration for Sway";
    extend = mkOption {
      description = "Extend the global config";
      type = types.bool;
      default = true;
    };
    wallpaperPath = mkOption {
      description = "A path to your wallpaper ";
      type = types.str;
      default = "$HOME/.wallpaper";
    };

  };
  config = mkIf cfg.enable {
    xdg.configFile."sway/config" = {
      text = ''
        include /etc/sway/config
        output * bg ${cfg.wallpaperPath} fill
      '';
    };
  };
}

