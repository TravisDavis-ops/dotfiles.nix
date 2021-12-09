{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.waybar;
  hostCfg = config.machineData;
  helpers = import ./helpers.nix;
in with helpers; {
  options.local.waybar = { enable = mkEnableOption "Enable Waybar"; };
  config = mkIf cfg.enable {
    xdg.configFile = {
      "waybar/style.css" = {
            source = ./style.css;
      };
      "waybar/config" = {
        text = builtins.toJSON {
          layer = "top";
          output = [ "DP-1" "DP-2" ];
          position = "top";
          modules-left = [ "sway/workspaces" "idle_inhibitor" ];
          modules-center = [ "clock" ];
          modules-right = [
            "disk#Os"
            "disk#Home"
            "disk#Steam"
            "disk#Archive"
            "cpu"
            "temperature"
            "network"
          ];
          "sway/workspaces" = {
            format = "{name}: {icon}";
            all-outputs = false;
            format-icons = {
              "1" = "I";
              "2" = "II";
              "3" = "III";
              "4" = "IV";
              "5" = "V";
              "6" = "VI";
            };
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          "temperature" = {
            critical-threshold = 58;
            format-critical = "🥵{temperatureC}°C";
            format = "{temperatureC}°C";
          };
          "network" = {
            "format-wifi" = "🔽:{bandwidthDownBits}, 🔼:{bandwidthUpBits}";
            "format-ethernet" = "{ifname}: {ipaddr}";
            "format-linked" = "{ifname} (No IP)";
            "format-disconnected" = "Disconnected";
            "format-alt" = "{ifname}: {ipaddr}";
          };
          "disk#Os" = {
            path = "/";
            interval = 60;
            format="OS:({free}, {used})/{total}";
          };
          "disk#Home" = {
            path = "/home";
            interval = 60;
            format = "HOME:({free}, {used})/{total}";
          };
          "disk#Steam" = {
            path = "/mnt/HotStorage";
            interval = 60;
            format ="Steam:({free}, {used})/{total}";
          };
          "disk#Archive" = {
            path = "/mnt/media";
            interval = 60;
            format="Archive:({free}, {used})/{total}";
          };
        };
      };
    };

    systemd.user.services = {
      "waybar" = {
        Unit = { Description = "Start Waybar"; };
        Service = {
          Type = "oneshot";
          RemainAfterExit = false;
          ExecStart = "${pkgs.waybar}/bin/waybar ";
          ExecStop = "kill -s SIGTERM $(pidof waybar)";
        };
        Install = { WantedBy = [ "multi-user.target" ]; };
      };
    };
  };
}
