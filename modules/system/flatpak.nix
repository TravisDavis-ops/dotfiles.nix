{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.flatpak;
in
{
  options.local.flatpak = {
    enable = mkOption {
      description = "Enable Flatpak";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    xdg.portal.enable = true;
    services.flatpak.enable = true;
  };
}
