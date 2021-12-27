{
  description = ''
    Nixos flake for deploying various system configrations & Home-manager profiles.
    base on [NixOS Configuration with Flakes](https://jdisaacs.com/blog/nixos-config/).
  '';

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/master";
    waypkgs.url = "github:nix-community/nixpkgs-wayland/master";
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, waypkgs, ... }@repos:
    let
      system = "x86_64-linux";
      meta = import ./meta.nix { };
      lib = (import ./lib { inherit system nixpkgs nur home-manager waypkgs; });
      pkgs = import nixpkgs { config.allowUnfree = true; inherit system; overlays = [ waypkgs.overlay ]; };
      nur = import ./pkgs { inherit system pkgs home-manager lib meta; };
    in
    {
      nixosConfigurations = import ./hosts { inherit system nixpkgs home-manager lib nur meta; };
      nixosModules = {
         anime-hub = import ./modules/nixos/anime-hub;
      };
      templates = import ./templates;
      inherit lib;
    } // flake-utils.lib.eachSystem [ system ] (system: {
      packages = nur;
    });
}
