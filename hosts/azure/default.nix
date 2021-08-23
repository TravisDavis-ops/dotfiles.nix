{ pkgs, builders, ... }:
let drives = import ./drives;
in
builders.mkHostSystem {
  inherit drives;
  name = "azure";
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
    nameservers = [ "127.0.0.1" ];
    interfaces.eth0 = {
      useDHCP = true;
      ipv4.addresses = [
        { address = "192.168.143.44"; prefixLength = 24; }
        { address = "45.79.214.146"; prefixLength = 24; }
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
