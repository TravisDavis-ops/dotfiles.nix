{
  description = ''
    WIP( nix flake ) for deploying various system configrations & User profiles.
    there are some know issues,
      - Limit 1 GOG game in profile
    base on [NixOS Configuration with Flakes](https://jdisaacs.com/blog/nixos-config/).
  '';

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@repos:
    let
      system = "x86_64-linux";

      # Meta Data
      meta = import ./meta.nix;

      # Nix Overlays
      overlays = import ./overlays;

      # Nix Library
      inherit (nixpkgs) lib;

      nix = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      libs = import ./libs { inherit system nix home-manager lib; };

      inherit (libs) builders utils;

      # Private Packages
      nur = (import ./pkgs { inherit nix builders; });

      # Configured Systems
      hosts = import ./hosts { inherit nur nix builders; };
      containers = import ./containers;
      # User Profiles
      profiles = import ./profiles { inherit nur nix builders; };

      # User Scripts
      scripts = import ./scripts { inherit nix meta; };
    in {

      apps.x86_64-linux = {

        # Install target host configuration
        install = utils.Script2App { scriptPath = scripts.install; };

        # Activate homemanager profile
        activate = utils.Script2App { scriptPath = scripts.activate; };

        #lint = utils.Script2App { scriptPath = scripts.lint; };

        build = utils.Script2App { scriptPath = scripts.build; };

      };

      packages.x86_64-linux = { inherit nur; };

      nixosConfigurations = hosts;

      homeManagerConfigurations = profiles;
    };
}
