{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.anime-hub.containers;
in
with builtins; {
  imports = [ ./shoko.nix ./komga.nix ./pihole.nix ./jellyfin.nix ];
  options.local.anime-hub.containers = {
    mediaFolder = mkOption { type = types.str; };
  };
}
