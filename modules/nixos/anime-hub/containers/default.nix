{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.os.p.anime-hub.containers;
in
with builtins; {
  imports = [ ./shoko.nix ./komga.nix ./pihole.nix ./jellyfin.nix ];
  options.os.p.anime-hub.containers = {
    mediaFolder = mkOption { type = types.str; };
  };
}
