{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.mako;

  bar-cmd = pkgs.writeShellScriptBin "bar-cmd" ''
    source /etc/profile
    export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -f 'sway$').sock
    ${pkgs.mako}/bin/waybar
  '';
in {
  options.local.mako = { enable = mkEnableOption "Mako(Service)"; };
  config = mkIf cfg.enable {
    programs.mako = {
      enable = true;
      anchor = "bottom-center";
    };
    systemd.user.services.notification-starter= {
      Unit = {
        Description = "Notification daemon";
        PartOf = [ "graphical.target" ];
        After = [ "graphical.target" ];
      };
      Install = { WantedBy = [ "graphical.target" ]; };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.mako}/bin/mako";
        ExecReload = "${pkgs.mako}/bin/makoctl reload";
        RestartSec = 5;
        Restart = "on-failure";
        KillMode = "mixed";
      };
    };

  };
}
