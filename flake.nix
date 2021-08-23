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
  };

  outputs = { self, nixpkgs, home-manager, ... }@repos:
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

      # Config Builders
      builders =
        (import ./libs { inherit system nix home-manager lib; }).builders;

      # Simple transformer
      Script2App = { scriptPath }: {
        type = "app";
        program = builtins.toPath scriptPath;
      };

      # Private Packages
      nur = (import ./pkgs { inherit nix builders; });

      # Configured Systems
      hosts = import ./hosts { inherit nur nix builders; };

      # User Profiles
      profiles = import ./profiles { inherit nur nix builders; };

      # User Scripts
      scripts = import ./scripts { inherit nix meta; };

    in
    {

      apps.x86_64-linux = {

        # Install target host configuration
        # TODO(travis) add params for hostname
        install = Script2App { scriptPath = scripts.install; };

        # Activate homemanager profile
        # TODO(travis) add  params for profile
        activate = Script2App { scriptPath = scripts.activate; };

        # Build flake repo
        # TODO(travis) is this even a good way to make sure everything is working
        build = Script2App { scriptPath = scripts.build; };

      };

      packages.x86_64-linux = { inherit nur; };

      # HomeManger Profiles
      homeManagerConfigurations = profiles;

      # NixOs Host
      nixosConfigurations = hosts;
    };
}
