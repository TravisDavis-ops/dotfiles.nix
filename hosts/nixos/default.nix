{ pkgs, nur, builders, common, ... }:
builders.mkHostModules rec {
  hostName = "nixos";

  kernel = {
    package = pkgs.linuxPackages;
  };

  users = [
    {
      name = "user";
      groups = [ "wheel" ];
      shell = pkgs.fish;
      password = "nixos";
    }
  ];

  modules = {
    sway = {
      enable = true;
      autoLogin = "user";
      programs = with pkgs; [
        swaylock-effects
        swayidle
        autotiling
        wl-clipboard
        libnotify
        pop-icon-theme
        dmenu
        firefox-wayland
        sway-contrib.inactive-windows-transparency
      ];
    };
  };
}
