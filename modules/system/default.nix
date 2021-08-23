{ pkgs, config, lib, ... }: {
  imports = [
    ./sway
    ./udev
    ./docker.nix
    ./flatpak.nix
    ./thinkfan.nix
    ./joycond.nix
    ./pipewire
    ./usbtop.nix
  ];
}
