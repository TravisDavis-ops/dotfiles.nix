{ system, nixpkgs, nur, home-manager, waypkgs,... }@inputs: rec {

  callPackage = inputs.callPackageWith inputs;

  mkProfile = callPackage ./mkProfile.nix { lib = nixpkgs.lib; };

  mkUser = import ./mkUser.nix;

  mkHostSystem = callPackage ./mkHostSystem.nix {
    inherit mkUser waypkgs;
    lib = nixpkgs.lib;
  };

  mkGogPackage = import ./mkGogPackage.nix;
  mkInterface = import ./mkInterface.nix;
  mkPeer = import ./mkPeer.nix;
}
