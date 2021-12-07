{ nix, meta }:
with nix; {
  # TODO(travis) add params
  activate = writeShellScript "activate.sh" ''
    nix build .#homeManagerConfigurations.$1.activationPackage;
    ./result/activate
  '';

  # TODO(travis) add params
  install = writeShellScript "install.sh" ''
    sudo nixos-rebuild switch --flake .#$1;
  '';


}
