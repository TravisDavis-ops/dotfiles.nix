{ config, pkgs, nur, ... }:
let
  start-wm = pkgs.writeShellScriptBin "start-wm" ''
    systemctl --user import-environment
    exec systemctl --user start sway.service
  '';
in
{
  imports = [ ];
  # config.nixpkgs.config.allowUnfree = true;
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.packages = [ start-wm ] ++ (with nur; [
    xxh
    cocogitto
    one-step-from-eden
    stardew-valley
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
    mako = {enable = true;};
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
      fileRules = [
        {
          extension = "nix";
          command = "nvim";
        }
        {
          extension = "rs";
          command = "nvim";
        }
        {
          extension = "toml";
          command = "nvim";
        }
        {
          extension = "md";
          command = "nvim";
        }
      ];
    };
  };
}
