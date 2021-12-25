{ pkgs, nur, builders, common, ... }:
let
  drives = import ./drives;
in
builders.mkHostSystem rec {
  inherit drives;

  hostName = "ruby";

  hardware = {
    pulseaudio = {
      enable = true;
      extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    cpu.amd.updateMicrocode = true;
  };

  kernel = {
    package = pkgs.linuxPackages;
    earlyModules = [ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod"];
    lateModules = [ "kvm-amd" "amdgpu" "radeon"];
    params = [ ];
  };

  bootLoader = {
    efi = { canTouchEfiVariables = true; };
    systemd-boot = { enable = true; graceful = true; };
  };

  network = {
    nameservers = [ "127.0.0.1" "1.1.1.1" "8.8.8.8" ];
    interfaces = {
      enp9s0.useDHCP = true;
      wlan0.useDHCP = true;
    };
  };

  wifi = {
    enable = false;
    iwd.enable = true;
  };

  userAccounts = [{
    name = "tod";
    groups = [ "wheel" "uinput" "dialout" ];
    shell = pkgs.fish;
  }
    {
      name = "mgnt";
      groups = [ "wheel" "docker" ];
      shell = pkgs.fish;
    }];

  config = {
    greetd.enable = true;
    sway = common.sway { enable = true; };
    mpd = {
      enable = true;
      pulseFix = true;
      musicPath = "/mnt/media/Music/";
    };
    udev.enable = true;
    docker.enable = true;
    flatpak.enable = true;
  };

  cpuCores = 4;
}
