{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.waybar;

  bar-cmd = pkgs.writeShellScriptBin "bar-cmd" ''
    source /etc/profile
    export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -f 'sway$').sock
    ${pkgs.waybar}/bin/waybar
  '';
in
{
  options.local.waybar = { enable = mkEnableOption "Waybar(Service)"; };
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
    };
    systemd.user.services.bar-starter = {
      Unit = {
        Description = "Graphical bar daemon";
        After = [ "default.target" ];
      };
      Install = { WantedBy = [ "basic.target" ]; };
      Service = {
        ExecStart = "${bar-cmd}/bin/bar-cmd";
        ExecReload = "kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };
    };

  };
}
