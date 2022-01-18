{ system
, nixpkgs
, lib
, mkUser
, reduceToAttr
, callProfile
, ...
}: { hostName
   , users
   , bootloader ? { }
   , hardware ? { }
   , kernel ? { }
   , drives ? { boot = { }; extra = { }; swap = [ ]; }
   , network ? { }
   , wifi ? { }
   , modules ? { }
   , services ? { }
   , cores ? 1
   , ...
   }: with builtins;
let
  inherit (drives) boot extra swap;

  noCheck = set: mapAttrs (k: v: v // { noCheck = true; }) set;

  userAccounts = map (u: mkUser u) users;
  profiles = reduceToAttr (map (u: callProfile hostName u.name) users);
  pkgs = nixpkgs.legacyPackages.${system};
in
with pkgs; {
  host = {
    imports = [ ../../modules/system ] ++ userAccounts;

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Chicago";

    environment = {
      systemPackages = [ direnv nix-direnv ];
      pathsToLink = [ "/share/nix-direnv" ];
    };

    nix = {
      package = nixUnstable;
      extraOptions = ''
        extra-experimental-features = nix-command
        extra-experimental-features = flakes
        keep-outputs = true
        keep-derivations = true
      '';
      maxJobs = lib.mkDefault cores;
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

    nixpkgs.overlays = [
      (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; })
    ];

    boot = {
      kernelPackages = lib.mkIf (hasAttr "package" kernel) kernel.package;
      kernelModules = lib.mkIf (hasAttr "lateModules" kernel) kernel.lateModules;
      initrd.availableKernelModules = lib.mkIf (hasAttr "earlyModules" kernel) kernel.earlyModules;
      kernelParams = lib.mkIf (hasAttr "params" kernel) kernel.params;

      cleanTmpDir = false;
      runSize = "40%";
      loader = bootloader;
    };

    hardware = hardware // {
      enableRedistributableFirmware = true;
    };

    users.groups = { input = { }; uinput = { }; };

    fileSystems = boot // noCheck extra;

    swapDevices = lib.mkIf (hasAttr "swap" drives) ([ ] ++ drives.swap);

    networking = {
      inherit hostName;
      useDHCP = false;
      wireless = wifi;
    } // network;

    inherit services;
    os.p = modules;
    system.stateVersion = "21.05";
  };

  inherit profiles;
}
