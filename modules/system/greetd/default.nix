{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.greetd;

in
{
  options.local.greetd = {
    enable = mkOption {
      description = "Enable Greetd";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      package = pkgs.greetd.wlgreet;
      settings = {
        default_session = {
          command = "sway";
          user = "tod";
        };
      };
    };
  };
}
