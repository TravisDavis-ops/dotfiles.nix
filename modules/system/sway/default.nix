{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.sway;
in
{
  options.local.sway = {
    enable = mkOption {
      description = "enable sway";
      type = types.bool;
      default = false;
    };
    programs = mkOption {
      description = "programs to be installed with sway";
      type = with types; listOf package;
      default = [ ];
    };
    systemConfig = mkOption {
      description = "a global config to be placed in etc/sway/";
      type = types.path;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = cfg.programs;
    };

    environment.etc = mkIf ((stringLength cfg.systemConfig)>0) {
      "sway/config".source = cfg.systemConfig;
    };
  };
}
