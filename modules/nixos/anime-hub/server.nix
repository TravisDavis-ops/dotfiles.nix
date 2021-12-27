{ config, pkgs, lib, ... }:
with lib;
let cfg = config.os.p.anime-hub.server;
in
{
  options.os.p.anime-hub.server = with types; {
    enable = mkEnableOption "configure anime-hub's nginx server";
    bond = mkOption {
      type = attrsOf anything;
      description = "an address and port for nginx to listen on";
      default = { addr = "127.0.0.1"; port = 80; };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
    };
  };
}
