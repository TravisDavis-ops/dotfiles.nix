{ system, nix, lib, mkUser, ... }@inputs:
with builtins;
{ name
, drives
, hardware
, interfaces
, initrdModules
, kernelModules
, kernelParams
, kernelPackages
, systemConfig
, cpuCores
, users
, bootLoader
, wifi ? [ ]
, gpuTempSensor ? null
, cpuTempSensor ? null
}:
let
  inherit (drives) boot;
  inherit (drives) extra;

  networkCfg = listToAttrs (map
    (n: {
      name = "${n}";
      value = { useDHCP = true; };
    })
    interfaces);
  userCfg = {
    inherit name interfaces systemConfig cpuCores gpuTempSensor cpuTempSensor;
  };
  systemUsers = (map (u: mkUser u) users);

in
lib.nixosSystem {
  inherit system;
  modules = [{
    imports = [ ../../modules/system ] ++ systemUsers;
    local = systemConfig;
    users.groups = {
      uinput = { name = "uinput"; };
      docker = { name = "docker"; };
      sudo = { name = "sudo"; };
      wireshark = { name = "wireshark"; };
    };

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Chicago";

    environment.etc = { "hmsystemdata.json".text = toJSON userCfg; };

    fileSystems = boot // extra;
    networking = {
      hostName = "${name}";
      useDHCP = false;
      interfaces = networkCfg;
      wireless = wifi;
    };

    boot = {
      initrd.availableKernelModules = initrdModules;
      inherit kernelParams kernelModules kernelPackages bootLoader;
      cleanTmpDir = false;
      runSize = "40%";
      loader = bootLoader;
      #{
      #  efi = { canTouchEfiVariables = true; };
      #  systemd-boot = { enable = true; graceful = true; };
      #};
    };

    nixpkgs = {
      pkgs = nix;
      config.allowUnfree = true;
    };

    nix = {
      package = nix.nixUnstable;
      extraOptions = ''
        extra-experimental-features = nix-command
        extra-experimental-features = flakes
      '';
      maxJobs = lib.mkDefault cpuCores;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };
    };
    hardware = hardware // {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };
    system.stateVersion = "21.05";
  }];
}
