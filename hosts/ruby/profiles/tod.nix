{ config, pkgs, nur, ... }: {
  imports = [ ];
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.packages = (with nur; [
    cocogitto
    stardew-valley
    slay-the-spire
    swayhide
    nhentai
  ]) ++ (with pkgs; [
    bpytop
    sysstat
    entr
    vlc
    zoxide
    bitwarden
    qbittorrent
    nixpkgs-fmt
    nixfmt
    exa
  ]);
  home.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    GDK_DPI_SCALE = 1;
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland-egl";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    SDL_VIDEODRIVER = "wayland";
    WLR_NO_HARDWARE_CURSORS = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";
    EDITOR = "nvim";
    VISUAL = "nvim";
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

  local = {
    sway = { enable = true; };
    waybar = { enable = true; };
    mako = { enable = true; };
    git = {
      enable = true;
      enableStore = true;
      userName = "travisdavis-ops";
      userEmail = "travisdavismedia@gmail.com";
    };

    neovim = {
      enable = true;
      enableFull = true;
      enableRust = true;
      enablePython = true;
      enableNix = true;
      enableC98 = true;
    };

    ranger = {
      enable = true;
      enablePreviews = true;
      enableVcs = true;
    };
  };
}
