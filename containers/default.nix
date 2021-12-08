{ config, pkgs, lib,...}:
with lib;
let cfg = config.local.containers;
in
{
    imports = [
        ./nextcloud.nix
    ];

    options.local.containers = {
        enable = mkEnableOption "Enable Containers";

    };
    config = mkIf cfg.enable {

    };

}
