{ pkgs }: {
  sway = { enable }: {
    inherit enable;
    autoLogin = "tod";
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
}
