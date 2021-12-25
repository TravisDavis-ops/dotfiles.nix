{ pkgs, builders, ... }:
let
  drives = import ./drives;
in
builders.mkHostSystem {
  inherit drives ;
  hostName = "azure";
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = false;
  };
  kernel = {
    package = pkgs.linuxPackages;
    earlyModules= [ "virtio_pci" "virtio_scsi" "ahci" ];
    lateModules = [ ];
    params = [ "console=ttyS0,19200n8" ];
  };

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
        terminal_output serial
      '';
    };
  };
  network = {
    nameservers = [ "50.116.41.5" "23.239.18.5" "74.207.231.5" ];
    interfaces.eth0 = {
      useDHCP = true;
      ipv4 = {
        addresses = [
          { address = "192.168.143.44"; prefixLength = 24; }
        ];
      };
    };
  };
  wifi = { enable = false; };

  users = [
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

  cores = 1;
}
