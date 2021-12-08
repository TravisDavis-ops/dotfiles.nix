{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.nextcloud;
in
{
  options.local.nextcloud= {
  };
  config = mkIf cfg.enable {
    containers.database = {
        { config = {config, pkgs, ...}: {
            services.mysql = {
            enable = true;
            package = pkgs.mariadb;
        };
        };}
    };
  };
}
