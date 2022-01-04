{ system, nixpkgs, nur, home-manager, ... }@inputs: rec {

  callPackage = inputs.callPackageWith (inputs // {
    inherit (nixpkgs) lib;
    inherit mkUser mkHostModules;
  });


  mkUser = import ./mkUser.nix;
  mkGogPackage = import ./mkGogPackage.nix;

  mkProfile = callPackage ./mkProfile.nix {};
  mkHostModules = callPackage ./mkHostModules.nix {};
  mkHostSystem = callPackage ./mkHostSystem.nix { };

}
