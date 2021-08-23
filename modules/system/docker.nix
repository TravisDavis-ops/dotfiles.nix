{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.docker;
in
{
  options.local.docker = {
    enable = mkOption {
      description = "Enable docker";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {

    virtualisation.docker = {
      enable = true;
      liveRestore = false;
    };
  };
}
