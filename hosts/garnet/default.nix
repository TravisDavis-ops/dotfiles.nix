{ pkgs, builders, common, ... }:
let
  swayConfig = import ./swayConfig.nix;
  drives = import ./drives;
in
builders.mkHostSystem {
  inherit drives;
  hostName = "garnet";
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  kernel = {
    package = pkgs.linuxPackages;
    earlyModules =[ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" ] ;
    lateModules = [ "kvm-intel" ];
    params = [];
  };

  bootLoader = {
    efi = { canTouchEfiVariables = true; };
    systemd-boot = { enable = true; graceful = true; };
  };

  wifi = {
    enable = true;
    interfaces = [ "wlp1s0" ];
    networks.Rockman = { psk = "rockman.exe"; };
  };

  users = [{
    name = "tod";
    groups = [ "wheel" ];
    shell = pkgs.fish;
  }];

  config = { sway = common.sway { enable = true; }; };

  cpuCores = 4;
}
