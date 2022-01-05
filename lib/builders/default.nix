{ system, nixpkgs, nur, home-manager, ... }@inputs: rec {

  callPackage = inputs.callPackageWith (inputs // {
    inherit (nixpkgs) lib;
    inherit mkUser mkHostModules mkNixGame mkWinGame mkHostSystem ;
  });


  mkUser = ./mkUser.nix;

  mkNixGame = callPackage ./mkNixGame.nix {};
  mkWinGame = callPackage ./mkWinGame.nix {};

  # mkProfile = callPackage ./mkProfile.nix {};

  mkHostModules = callPackage ./mkHostModules.nix {};
  mkHostSystem = callPackage ./mkHostSystem.nix { };

}
