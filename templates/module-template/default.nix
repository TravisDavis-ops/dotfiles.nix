{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.module;

in
{
  options.local.module = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable { };
}
