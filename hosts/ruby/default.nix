{ nix, builders, ... }:
let
  swayConfig = import ./swayConfig.nix;
  drives = import ./drives;
in
builders.mkHostSystem {
  inherit drives;
  name = "ruby";
  hardware = {
    pulseaudio.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    cpu.amd.updateMicrocode = true;
    fancontrol = {
      enable = true;
      config = ''
        INTERVAL=10
        DEVPATH=hwmon1=devices/pci0000:00/0000:00:01.2/0000:04:00.0/usb1/1-8/1-8:1.0/0003:1B1C:0C10.0005 hwmon2=devices/pci0000:00/0000:00:18.3
        DEVNAME=hwmon1=corsaircpro hwmon2=k10temp
        FCTEMPS=hwmon1/pwm2=hwmon2/temp1_input hwmon1/pwm1=hwmon2/temp2_input
        FCFANS=hwmon1/pwm2=hwmon1/fan2_input hwmon1/pwm1=hwmon1/fan1_input
        MINTEMP=hwmon1/pwm2=35 hwmon1/pwm1=35
        MAXTEMP=hwmon1/pwm2=65 hwmon1/pwm1=65
        MINSTART=hwmon1/pwm2=75 hwmon1/pwm1=150
        MINSTOP=hwmon1/pwm2=25 hwmon1/pwm1=25
        MINPWM=hwmon1/pwm2=15 hwmon1/pwm1=15
        MAXPWM=hwmon1/pwm2=200 hwmon1/pwm1=200

      '';

    };
  };

  interfaces = [ "enp9s0" "wlp8s0" ];
  kernelPackages = nix.linuxPackages_latest;
  initrdModules = [ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" ];
  kernelModules = [ "kvm-amd" "amdgpu" "radeon" ];
  kernelParams = [ ];

  systemConfig = {
    sway = swayConfig;
    udev.enable = true;
    docker.enable = true;
    flatpak.enable = true;
    usbtop.enable = false; #  wasnt helpful remove incoming or usb dev profile
    pipewire.enable = false; # audio started to cut out at times
  };

  wifi = {
    enable = true;
    interfaces = [ "wlp8s0" ];
    networks.Rockman = { psk = "rockman.exe"; };
  };

  users = [{
    name = "tod";
    groups = [ "wheel" "docker" "dialout" ];
    shell = nix.fish;
  }];
  cpuCores = 4;

}
