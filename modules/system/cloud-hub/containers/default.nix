{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.os.p.anime-hub.containers;
in
with builtins; {
  imports = [ ];
  options.os.p.sync-hub.containers = { };
}
