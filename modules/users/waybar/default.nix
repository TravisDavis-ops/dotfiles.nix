{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.waybar;
  hostCfg = config.machineData;
  helpers = import ./helpers.nix;
in
with helpers; {
  options.local.waybar = {
    enable = mkEnableOption "Enable Waybar";
  };
  config = mkIf cfg.enable {
    xdg.configFile = {
      "waybar/config" = {
        text = builtins.toJSON {
          layer = "top";
          output = [
            "DP-1"
            "DP-2"
          ];
          position = "top";
          modules-left = [ "wlr/taskbar" ];
          modules-center = [ ];
          modules-right = [ ];
          "wlr/taskbar" = {
            format = "{icon}{app_id}";
            on-click = "activate";
            on-click-middle = "close";
            on-click-right = "fullscreen";
          };
        };
      };
    };

    systemd.user.services = {
      "waybar" = {
        Unit = { Description = "Start Waybar"; };
        Service = {
          Type = "oneshot";
          RemainAfterExit=false;
          ExecStart = "${pkgs.waybar}/bin/waybar ";
          ExecStop = "kill -s SIGTERM $(pidof waybar)";
        };
        Install = { WantedBy = [ "multi-user.target" ]; };
      };
    };
  };
}
