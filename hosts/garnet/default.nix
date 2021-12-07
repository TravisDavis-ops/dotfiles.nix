{ nix, builders, ... }:
let
  swayConfig = import ./swayConfig.nix;
  drives = import ./drives;
in
builders.mkHostSystem {
  inherit drives;
  name = "garnet";
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  interfaces = [ "wlp1s0" ];
  kernelPackages = nix.linuxPackages;
  initrdModules = [ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" ];
  kernelModules = [ "kvm-intel" ];
  kernelParams = [ ];

  bootLoader = {
    efi = { canTouchEfiVariables = true; };
    systemd-boot = { enable = true; graceful = true;};
  };

  wifi = {
    enable = true;
    interfaces = [ "wlp1s0" ];
    networks.Rockman = { psk = "rockman.exe"; };
  };

  users = [{
    name = "tod";
    groups = [ "wheel" ];
    shell = nix.fish;
  }];

  systemConfig = { sway = swayConfig; };

  cpuCores = 4;

}