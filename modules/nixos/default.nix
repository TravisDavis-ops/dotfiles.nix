{ pkgs, config, lib, ... }: let
  cfg = config.os.p;
in with lib; {
  imports = [
    ./docker
    ./openssh
    ./flatpak
    ./qmk-rules
    ./anime-hub
    ./sway
    ./mpd
  ];

}
