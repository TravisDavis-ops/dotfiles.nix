{ system, nixpkgs, nur, home-manager, ... }@inputs:
let
  callPackage = inputs.callPackageWith ((inputs // self) // { inherit (nixpkgs) lib; });
  self = {
    mkUser = import ./mkUser.nix;
    mkNixGame = callPackage ./mkNixGame.nix { };
    mkWinGame = callPackage ./mkWinGame.nix { };
    mkWin64Game = callPackage ./mkWin64Game.nix { };
    # mkProfile = callPackage ./mkProfile.nix {};
    mkHostModules = callPackage ./mkHostModules.nix { };
    mkHostSystem = callPackage ./mkHostSystem.nix { };
  };
in
self
