{ pkgs, builders, ... }:
let drives = import ./drives;
in
builders.mkHostSystem {
  inherit drives;
  name = "jade";
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = false;
  };
  kernelPackages = pkgs.linuxPackages;
  initrdModules = [ "virtio_pci" "virtio_scsi" "ahci" ];
  kernelModules = [ ];
  kernelParams = [ "console=ttyS0,19200n8" ];

  bootLoader = {
    timeout = 0;
    grub = {
      enable = true;
      forceInstall = true;
      device = "nodev";
      version = 2;
      extraConfig = ''
        serial --speed=19200 --unit=0 --parity=no --stop=1;
        terminal_input serial;
        terminala_output serial
      '';
    };
  };
  network = {
    # nameservers = [];
    interfaces.eth0 = {
      useDHCP = true;
      ipv4.addresses = [
        {
          address = "192.168.136.123";
          prefixLength = 24;
        }
        {
          address = "172.105.148.34";
          prefixLength = 24;
        }
      ];
    };
  };
  wifi = { enable = false; };

  userAccounts = [
    {
      name = "tod";
      groups = [ "wheel" "docker" ];
      shell = pkgs.fish;
    }
    {
      name = "mgnt";
      groups = [ "wheel" "docker" ];
      shell = pkgs.fish;
    }
  ];

  config = {
    openssh.enable = true;
    docker.enable = true;
  };

  cpuCores = 1;
}