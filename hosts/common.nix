{ pkgs }: {
  sway = { enable }: {
    inherit enable;
    autoLogin = "tod";
    programs = with pkgs; [
      swaylock
      swayidle
      autotiling
      wl-clipboard
      libnotify
      waybar
      mako
      wofi
      dmenu
      kitty
      firefox-wayland
      sway-contrib.inactive-windows-transparency
    ];
    systemConfig = ./configs/config.sway;
  };
}
