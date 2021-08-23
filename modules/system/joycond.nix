{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.joycond;
in
{
  options.local.joycond = {
    enable = mkOption {
      description = "Enable Joycon Support";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable { services.joycond.enable = true; };
}
