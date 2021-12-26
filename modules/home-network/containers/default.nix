{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.home-network.containers;
in
with builtins; {
  imports = [ ./shoko.nix ./komga.nix ./pihole.nix ./jellyfin.nix ];
  options.local.home-network.containers = {
    mediaFolder = mkOption { type = types.str; };
  };
}
