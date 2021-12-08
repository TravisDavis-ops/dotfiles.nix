{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.nextcloud;
in {
  options.local.nextcloud = {
    enable = mkEnableOption "Enable nextcloud container";
  };
  config = mkIf cfg.enable { virtualisation.oci-containers.containers = { }; };
}
