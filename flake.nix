{
  description = ''
    Nixos flake for deploying various system configrations & Home-manager profiles.
    base on [NixOS Configuration with Flakes](https://jdisaacs.com/blog/nixos-config/).
  '';

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-gen.url = "github:nix-community/nixos-generators";
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nixos-gen, ... }@repos:
    let
      system = "x86_64-linux";
      meta = import ./meta.nix { };
      lib = (import ./lib { inherit system nixpkgs nur home-manager; });
      pkgs = import nixpkgs { config.allowUnfree = true; inherit system; overlays = [ ]; };
      nur = import ./pkgs { inherit system pkgs home-manager lib meta; };
      hosts = import ./hosts { inherit system nixpkgs home-manager lib nur meta; };
    in
    (
      let
        dist = {
          iso = nixos-gen.nixosGenerate {
            inherit pkgs;
            modules = with pkgs; [
              {
                imports = [ ./modules/system ];
                nix = {
                  package = nixUnstable;
                  extraOptions = ''
                    extra-experimental-features = nix-command
                    extra-experimental-features = flakes
                    keep-outputs = true
                    keep-derivations = true
                  '';
                };
                environment = {
                  systemPackages = [ direnv nix-direnv ];
                  pathsToLink = [ "/share/nix-direnv" ];
                };
              }
            ];
            format = "install-iso";
          };
        };
      in
      {
        nixosConfigurations = hosts;
        nixosModules = {
          anime-hub = import ./modules/nixos/anime-hub;
        };
        templates = import ./templates;
        inherit lib;
      } // flake-utils.lib.eachSystem [ system ] (system: {
        packages = nur // dist;
        devShell = with pkgs; mkShell {
          name = "dev-tools";
          packages = [
            (writeShellScriptBin "nixpkgs-fmt-safe" ''
              ${nixpkgs-fmt}/bin/nixpkgs-fmt $(find **/* -name "*.nix")
            '')
          ];
        };
      })
    );
}
