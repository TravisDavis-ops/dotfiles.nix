{ nix, meta }:
with nix; {
  # TODO(travis) add params
  activate = writeShellScript "activate.sh" ''
    nix build .#homeManagerConfigurations.$USER.activationPackage;
        ./result/activate
  '';

  # TODO(travis) add params
  install = writeShellScript "install.sh" ''
    sudo nixos-rebuild switch --flake .#$HOSTNAME;
  '';

  build = writeShellScript "build.sh" ''
    nixos-rebuild build  --flake .#$HOSTNAME;
    nix build .#homeManagerConfigurations.$USER.activationPackage;
  '';

}
