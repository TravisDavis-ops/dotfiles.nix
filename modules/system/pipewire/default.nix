{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.pipewire;

in
{
  options.local.pipewire = {
    enable = mkOption {
      description = "Enable pipewire";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
