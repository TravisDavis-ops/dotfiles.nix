{ pkgs, config, lib, ... }: {
  imports = [
    ./sway
    ./udev
    ./docker.nix
    ./flatpak.nix
    ./joycond.nix
    ./pipewire
    ./openssh.nix
    ./greetd
    ./mpd
    ./bond0.nix
  ];
}
