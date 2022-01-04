{ nur, nixpkgs, lib, system, ... }:
let
  pkgs = nixpkgs.legacyPackages.${system};
  common = import ./common.nix { inherit pkgs; };
  builders = lib.builders;
in
{
  ruby = import ./ruby { inherit pkgs nur builders common; };
  garnet = import ./garnet { inherit pkgs nur builders common; };
  azure = import ./azure { inherit pkgs nur builders common; };
  jade = import ./jade { inherit pkgs nur builders common; };
  iso = import ./iso { inherit pkgs nur builders common; };
}
