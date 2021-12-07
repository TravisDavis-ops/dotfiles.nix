{ nix, builders, ... }:
let
  drives = import ./drives;
in
builders.mkHostSystem {
  inherit drives;
  name = "azure";
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = false;
  };

  interfaces = [ "eth0" ];
  kernelPackages = nix.linuxPackages;
  initrdModules = [ "virtio_pci" "virtio_scsi" "ahci" ];
  kernelModules = [ ];
  kernelParams = [ "console=ttyS0,19200n8"];

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

  wifi = {
    enable = false;
  };

  users = [{
    name = "tod";
    groups = [ "wheel" ];
    shell = nix.fish;
  }];

  systemConfig = {
      openssh.enable = true;
  };

  cpuCores = 1;
}
