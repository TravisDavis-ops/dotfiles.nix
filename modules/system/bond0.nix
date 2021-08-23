{ config, pkgs, lib, ... }:
with lib;
let cfg = config.local.bond0;
in
{
  options.local.bond0 = {
    enable = mkOption {
      description = "Enable Bonded Network for wlan0 and wlan1";
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    systemd.network = {
      enable = true;
      netdevs."30-bond0" = {
        enable = true;
        netdevConfig = {
          Name = "bond0";
          Kind = "bond";
        };
        bondConfig = {
          Mode = "balance-tlb";
          PrimaryReselectPolicy = "always";
          MIIMonitorSec = "1s";
        };
      };
      networks = {
        "30-bond0" = {
          matchConfig = {
            Name = "bond0";
          };
          networkConfig = {
            DHCP = "ipv4";
          };
        };
        "30-wlan0-bond0" = {
          matchConfig = {
            Name = "wlan0";
          };
          networkConfig = {
            Bond = "bond0";
            PrimarySlave = true;
          };
        };
        "30-wlan1-bond0" = {
          matchConfig = {
            Name = "wlan1";
          };
          networkConfig = {
            Bond = "bond0";
            PrimarySlave = true;
          };

        };
      };
    };
  };
}
