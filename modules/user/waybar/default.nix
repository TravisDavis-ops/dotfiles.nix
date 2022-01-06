{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.waybar;

  waybar-server = pkgs.writeShellScriptBin "waybar-server" ''
    source /etc/profile
    export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -f 'sway$').sock
    ${pkgs.waybar}/bin/waybar
  '';
in
{
  options.local.waybar = { enable = mkEnableOption "Waybar(Service)"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pavucontrol jq ];
    programs.waybar = {
      enable = true;
      style = ./style.css;
    };
    xdg.configFile."waybar/config".source = ./config;

    systemd.user.services.waybar = {
      Unit = {
        Description = "waybar daemon";
        After = [ "default.target" ];
      };
      Install = { WantedBy = [ "basic.target" ]; };
      Service = {
        TimeoutStartSec = 120;
        ExecStart = "${waybar-server}/bin/waybar-server";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        RestartSec = 20;
        KillMode = "mixed";
      };
    };

  };
}
