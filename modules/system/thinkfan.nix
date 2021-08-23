{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.thinkfan;
in
{
  options.local.thinkfan = {
    enable = mkOption {
      description = "Enable Thinkfan";
      type = types.bool;
      default = false;
    };
    useCpu = mkOption {
      description = "Use cpu temperature sensors";
      type = types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    services.thinkfan = {
      enable = true;
      sensors = mkIf cfg.useCpu [{
        query = "/sys/class/hwmon/hwmon2";
        type = "hwmon";
        indices = [ 1 2 ];
      }];
      fans = mkIf cfg.useCpu [{
        query = "/sys/class/hwmon/hwmon1/";
        type = "hwmon";
        indices = [ 1 2 ];
      }];
      levels = mkIf cfg.useCpu [
        [ 0 30 35 ]
        [ 100 35 40 ]
        [ 150 40 50 ]
        [ 200 50 55 ]
        [ 255 55 32767 ]
      ];
    };
  };
}
