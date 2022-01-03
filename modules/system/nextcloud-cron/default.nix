{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.os.p.nextcloud-cron;

  cmd = pkgs.writeShellScriptBin "run-cron" ''
    source /etc/profile
    docker exec -u 33 nextcloud-app php -f /var/www/html/cron.php
  '';
in
{
  options.os.p.nextcloud-cron = {
    enable = mkEnableOption "Nextcloud cron timer";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ cmd ];
    systemd = {
      services.nextcloud-cron = {
        description = "Run Nextcloud's background task script";
        script = "source ${cmd}/bin/run-cron";
        serviceConfig = {
          KillMode = "process";
        };
      };
      timers.nextcloud-cron = {
        description = "Run Nextclouds's background task script 5 minutes";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "5min";
          OnUnitActiveSec = "5min";
          Unit = "nextcloud-cron.service";
        };
      };
    };
  };
}
