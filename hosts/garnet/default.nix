{ pkgs, builders, common, ... }:
let
  hostName = "garnet";
  drives = import ./drives;
in
builders.mkHostSystem {
  inherit hostName drives;

  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  kernel = {
    package = pkgs.linuxPackages;
    earlyModules = [ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" ];
    lateModules = [ "kvm-intel" ];
    params = [ ];
  };

  bootloader = {
    efi = { canTouchEfiVariables = true; };
    systemd-boot = { enable = true; graceful = true; };
  };

  wifi = {
    enable = true;
    interfaces = [ "wlp1s0" ];
    networks.Rockman = { psk = "rockman.exe"; };
  };

  users = [
    rec {
      name = "tod";
      groups = [ "wheel" ];
      shell = pkgs.fish;
      password = "${hostName}-${name}";
    }
  ];

  modules = { sway = common.sway { enable = true; }; };

  cores = 4;
}
