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

  kernelPackages = pkgs.linuxPackages;
  initrdModules = [ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" ];
  kernelModules = [ "kvm-intel" ];
  kernelParams = [ ];

  bootLoader = {
    efi = { canTouchEfiVariables = true; };
    systemd-boot = { enable = true; graceful = true; };
  };

  wifi = {
    enable = true;
    interfaces = [ "wlp1s0" ];
    networks.Rockman = { psk = "rockman.exe"; };
  };

  userAccounts = [{
    name = "tod";
    groups = [ "wheel" ];
    shell = pkgs.fish;
  }];

  config = { sway = common.sway { enable = true; }; };

  cpuCores = 4;
}
