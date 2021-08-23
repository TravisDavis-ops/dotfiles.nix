{ system ? builtins.currentSystem, ... }@inputs:

let
  nix = import <nixos> { inherit system; };
  self = {
    pkgs = import ./pkgs { inherit nix; };
    libs = import ./libs inputs;
  };
in
self

