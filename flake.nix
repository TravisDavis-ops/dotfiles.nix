{
  description = ''
    WIP( nix flake ) for deploying various system configrations & User profiles.
    there are some know issues,
    base on [NixOS Configuration with Flakes](https://jdisaacs.com/blog/nixos-config/).
  '';

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/master";
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@repos:
    let
      system = "x86_64-linux";
      meta = import ./meta.nix { };
      lib = (import ./libs { inherit system nixpkgs nur home-manager; });
      pkgs = import nixpkgs { config.allowUnfree = true; inherit system; };
      nur = import ./pkgs { inherit system pkgs home-manager lib meta; };
    in
    {
      packages.${system} = nur;
      nixosConfigurations = import ./hosts { inherit system nixpkgs home-manager lib nur meta; };
      inherit lib;
    };
}
