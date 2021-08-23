{ config, pkgs, nur, ... }:
let
  start-wm = pkgs.writeShellScriptBin "start-wm" ''
    systemctl --user import-environment
    exec systemctl --user start sway.service
  '';
  start-bar = pkgs.writeShellScriptBin "start-bar" ''
    . /etc/profile
    export SWAYSOCK=/run/user/$(id -u)/sway-ipc.$(id -u).$(pgrep -f 'sway$').sock
    export GTK_DEBUG=interactive
    ${pkgs.waybar}/bin/waybar
  '';
in
{
  imports = [ ../modules/users ];
  # config.nixpkgs.config.allowUnfree = true;
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.packages = [ start-bar start-wm nur.cocogitto nur.one-step-from-eden nur.stardew-valley nur.swayhide nur.nhentai pkgs.bpytop pkgs.sysstat ];

  systemd.user = {
    sockets.dbus = {
      Unit = {
        Description = "D-Bus User Message Bus Socket";
      };
      Socket = {
        ListenStream = "%t/bus";
        ExecStartPost = "${pkgs.systemd}/bin/systemctl --user set-environment DBUS_SESSION_BUS_ADDRESS=unix:path=%t/bus";
      };
      Install = {
        WantedBy = [ "sockets.target" ];
        Also = [ "dbus.service" ];
      };
    };
    services = {
      sway = {
        Unit = {
          Description = "Sway - Wayland window manager";
          Documentation = [ "man:sway(5)" ];
          BindsTo = [ "graphical-session.target" ];
          Wants = [ "graphical-session-pre.target" ];
          After = [ "graphical-session-pre.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.sway}/bin/sway";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      waybar = {
        Unit = {
          Description = "Wayland bar for Sway and Wlroots based compositors";
          PartOf = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${start-bar}/bin/start-bar";
          RestartSec = 5;
          Restart = "always";
        };
      };
      mako = {
        Unit = {
          Description = "Mako notification daemon";
          PartOf = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "dbus";
          BusName = "org.freedesktop.Notifications";
          ExecStart = "${pkgs.mako}/bin/mako";
          RestartSec = 5;
          Restart = "always";
        };
      };
      dbus = {
        Unit = {
          Description = "D-Bus User Message Bus";
          Requires = [ "dbus.socket" ];
        };
        Service = {
          ExecStart = "${pkgs.dbus}/bin/dbus-daemon --session --address=systemd: --nofork --nopidfile --systemd-activation";
          ExecReload = "${pkgs.dbus}/bin/dbus-send --print-reply --session --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ReloadConfig";
        };
        Install = {
          Also = [ "dbus.socket" ];
        };
      };
    };
  };

  local = {
    sway = { enable = true; };
    waybar = { enable = true; };

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
