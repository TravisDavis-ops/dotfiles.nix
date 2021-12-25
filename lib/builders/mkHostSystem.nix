{ system, lib, home-manager, nur, nixpkgs, reduceToAttr, callProfile, mkUser, ... }@inputs:
with builtins;
{ hostName
, drives
, hardware
, kernel
, config
, cpuCores
, userAccounts
, bootLoader
, network ? { }
, wifi ? { }

}:
let
  inherit (drives) boot extra swap;

  profiles = reduceToAttr (map (u: callProfile name u.name) userAccounts);
  users = map (u: mkUser u) userAccounts;

in
lib.nixosSystem {
  inherit system;
  modules = [
    {
      imports = [ ../../modules/system ] ++ users;

      i18n.defaultLocale = "en_US.UTF-8";
      time.timeZone = "America/Chicago";

      nix = {
        package = nixpkgs.legacyPackages.${system}.nixUnstable;
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

      boot = {
        kernelPackages = mkIf (hasAttr "package" kernel)  kernel.package;
        kernelModules = mkIf (hasAttr "lateModules" kernel)  kernel.lateModules;
        initrd.availableKernelModules = mkIf (hasAttr "earlyModules" kernel)  kernel.earlyModules;
        kernelParams = mkIf (hasAttr "params" kernel)  kernel.params;

        cleanTmpDir = false;
        runSize = "40%";
        loader = bootLoader;
      };

      hardware = hardware // {
        enableRedistributableFirmware = true;
      };

      fileSystems = boot // extra;
      inherit (swap) swapDevices;

      local = config;

      networking = {
        inherit hostName;
        useDHCP = false;
        wireless = wifi;
      } // network;


      system.stateVersion = "21.05";
    }
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = { inherit nur; };
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [ ../../modules/users ];
        users = profiles;
      };
    }
  ];
}
