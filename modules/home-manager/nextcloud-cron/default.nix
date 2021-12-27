{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.nextcloud-cron;

  cmd = pkgs.writeShellScriptBin "run-cron" ''
    docker exec -u 33 -it nextcloud-app php -f /var/www/html/cron.php
  '';
in
{
  options.local.nextcloud-cron = {
    enable = mkEnableOption "Nextcloud cron timer";
  };
  config = mkIf cfg.enable {
    home.packages = [ cmd ];
    systemd.user = {
      services.nextcloud-cron = {
        Unit = { Description = "Run Nextcloud-app's background cron"; };
        Service = {
          User = "mgnt";
          Group = "docker";
          ExecStart = "${cmd}/bin/run-cron";
          KillMode = "process";
        };
      };
      timers.nextcloud-cron-runner = {
        Unit = {
          Description = "Run Nextcloud background cron every 5 minutes";
        };
        Timer = {
          OnBootSec = "5min";
          OnUnitActiveSec = "5min";
          Unit = "nextcloud-cron.service";
        };
        Install = { WantedBy = [ "timers.target" ]; };
      };
    };
  };
}
