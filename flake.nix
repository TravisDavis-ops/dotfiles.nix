{
  description = ''
    Nixos flake for deploying various system configrations & Home-manager profiles.
  '';

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-gen.url = "github:nix-community/nixos-generators";
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nixos-gen, ... }@repos:
    with builtins;
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
        dist = let
            modules = (lib.builder.mkHostModules hosts.iso);
        in {
          iso = nixos-gen.nixosGenerate {
            inherit pkgs;
            modules = with pkgs; [
              # use home-manager for user environment
              home-manager.nixosModules.home-manager

              hosts.iso.host

              {
                home-manager = {
                  extraSpecialArgs = { inherit nur; };
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  sharedModules = [ ./modules/user ];
                  users = hosts.iso.profiles;
                };
              }
            ];
            format = "install-iso";
          };
        };
      in
      {
        nixosConfigurations = removeAttrs hosts [ "iso" ];
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
