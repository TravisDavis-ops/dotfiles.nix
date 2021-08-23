{ pkgs, config, lib, ... }: {
  imports = [
    ./sway
    ./udev
    ./docker
    ./flatpak
    ./joycond
    ./pipewire
    ./openssh
    ./greetd
    ./mpd
  ];
}
