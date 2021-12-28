{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.mako;
in
{
  options.local.mako = { enable = mkEnableOption "Mako(Service)"; };
  config = mkIf cfg.enable {
    programs.mako = {
      enable = true;
      anchor = "bottom-center";
      backgroundColor="#24283b";
      textColor="#c0caf5";
      width=350;
      margin="0,20,20";
      padding="10";
      borderSize=2;
      borderColor="#414868";
      borderRadius=5;
      defaultTimeout=10000;
      groupBy="summary";

    };
    systemd.user.services.notification-starter = {
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
