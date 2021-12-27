{ config, pkgs, lib, ... }:
with lib;
let cfg = config.os.p.docker;
in
{
  options.os.p.docker = {
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
