{ pkgs, nur, builders, common, ... }:
builders.mkHostSystem rec {
  hostName = "ruby";
  drives = import ./drives;

  bootloader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = { enable = true; graceful = true; };
  };

  hardware = {
    pulseaudio = {
      enable = true;
      extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
    };
    opengl.extraPackages = with pkgs; [
      amdvlk
    ];
    # For 32 bit applications
    # Only available on unstable
    opengl.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    cpu.amd.updateMicrocode = true;
  };

  kernel = {
    package = pkgs.linuxKernel.packages.linux_zen;
    earlyModules = [ "xhci_pci" "ahci" "nvme" "uas" "usbhid" "sd_mod" ];
    lateModules = [ "kvm-amd" "amdgpu" ];
    params = [ ];
  };

  users = [
    rec {
      name = "tod";
      groups = [ "wheel" "input" "uinput" "dialout" ];
      shell = pkgs.fish;
      password = "${hostName}-${name}";
    }
    rec {
      name = "mgnt";
      groups = [ "wheel" "docker" ];
      shell = pkgs.fish;
      password = "${hostName}-${name}";
    }
  ];

  network = {
    nameservers = [ "192.168.1.64:8080" "1.1.1.1" "8.8.8.8" ];
    interfaces = {
      enp9s0.useDHCP = true;
      wlan0.useDHCP = true;
    };
  };

  wifi = {
    enable = false;
    iwd.enable = true;
  };



  modules = {
    # gpu crashes could be jellyfin
    # anime-hub.enable = true
    anime-hub.containers = {
      mediaFolder = "/mnt";
      komga = {
        enable = true;
        hostPort = 8081;
        domainName = "ruby";
      };
    };
    docker.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
    qmk-rules.enable = true;
    sway = common.sway { enable = true; };
    mpd = {
      enable = true;
      pulseFix = true;
      musicPath = "/mnt/media/Music/";
    };
  };
  services = {
    joycond.enable = true;
  };
  cores = 4;
}
