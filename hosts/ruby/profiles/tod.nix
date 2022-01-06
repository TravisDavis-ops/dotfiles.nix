{ config, pkgs, nur, ... }: {
  imports = [ ];
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
  home = {
    packages = (with nur; [
      swayhide
      one-step-from-eden
      slime-rancher
      stardew-valley
      moonlighter
      dont-starve
      nhentai
    ]) ++ (with pkgs; [
      bpytop
      sysstat
      bitwarden
      qbittorrent
      exa
      nerdfonts
    ]);
    sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland";
      GDK_DPI_SCALE = 1;
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland-egl";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      WLR_NO_HARDWARE_CURSORS = 1;
      _JAVA_AWT_WM_NONREPARENTING = 1;
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";
    };
  };

  systemd.user = {
    sockets.dbus = {
      Unit = { Description = "D-Bus User Message Bus Socket"; };
      Socket = {
        ListenStream = "%t/bus";
        ExecStartPost =
          "${pkgs.systemd}/bin/systemctl --user set-environment DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus";
      };
      Install = {
        WantedBy = [ "sockets.target" ];
        Also = [ "dbus.service" ];
      };
    };
    services = {
      dbus = {
        Unit = {
          Description = "D-Bus User Message Bus";
          Requires = [ "dbus.socket" ];
        };
        Service = {
          ExecStart =
            "${pkgs.dbus}/bin/dbus-daemon --session --address=systemd: --nofork --nopidfile --systemd-activation";
          ExecReload =
            "${pkgs.dbus}/bin/dbus-send --print-reply --session --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig";
        };
        Install = { Also = [ "dbus.socket" ]; };
      };
    };
  };
  fonts.fontconfig.enable = true;

  programs = { };
  local = {
    mpd-player = { enable = true; };
    sway = { enable = true; };
    waybar = { enable = true; };
    mako = { enable = true; };
    wofi = { enable = true; };
    kitty = { enable = true; };
    fish = { enable = true; };
    git = {
      enable = true;
      enableStore = true;
      userName = "travisdavis-ops";
      userEmail = "travisdavismedia@gmail.com";
    };
    neovim = {
      enable = true;
      enableQol = true;
      enableRust = true;
      enablePython = true;
      enableNix = true;
      enableC99 = true;
      enableGui = true;
      port = 9000;
    };
    ranger = {
      enable = true;
      enablePreviews = true;
      enableVcs = true;
    };
  };
}
