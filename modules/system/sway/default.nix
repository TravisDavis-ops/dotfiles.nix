{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.sway;
  helpers = import ./helpers.nix;
  essential = with pkgs; [
    swaylock
    swayidle
    autotiling
    wl-clipboard
    libnotify
    sway-contrib.inactive-windows-transparency
  ];
  style = with pkgs; [ waybar mako pop-icon-theme ];
  applications = with pkgs; [ dmenu kitty wofi pavucontrol firefox-wayland ];
in
with helpers; {
  options.local.sway = {
    enable = mkOption {
      description = "Enable SwayExtended";
      type = types.bool;
      default = false;
    };

    enableFishLaunch = mkOption {
      description = "setup fish to auto launch sway";
      type = types.bool;
      default = false;
    };
    loginTTY = mkOption {
      description = "TTY to autostart sway on";
      type = types.str;
      default = "/dev/tty1";
    };
    variables = mkOption {
      description = "List of Variable for refecening in config";
      type = types.listOf (types.attrsOf types.anything);
      default = [{
        name = "$alt";
        value = "Mod1";
      }];
    };
    settings = mkOption {
      description = "sway config setting";
      type = types.listOf (types.attrsOf types.anything);
      default = [{
        key = "focus_follows_mouse";
        value = "yes";
      }];
    };
    workspaces = mkOption {
      description = "Configure Workspaces";
      type = types.listOf (types.attrsOf types.anything);
      default = [{
        name = "Master";
        output = "DP-1";
      }];
    };
    outputs = mkOption {
      description = "A list of outputs to configure on startup";
      type = types.listOf (types.attrsOf types.anything);
      default = [{
        name = "DP-1";
        mode = "1920x1080@60Hz";
        position = [ 0 0 ];
      }];
    };
    autostarts = mkOption {
      description = "A list of Programs to launch on startup";
      type = types.listOf (types.attrsOf types.anything);
      default = [{
        program = "echo";
        always = false;
        args = [ "HelloWorld" ];
      }];

    };

    keybindings = mkOption {
      description = "A list of keybindings";
      type = types.listOf (types.attrsOf types.anything);
      default = [{
        combo = "$alt+Shift+q";
        action = "kill";
      }];
    };
  };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      extraPackages = essential ++ style ++ applications;
    };

    programs.fish = mkIf cfg.enableFishLaunch {
      enable = true;
      loginShellInit = ''
        set fish_greeting
        set TTY (tty)
        if test -z "$DISPLAY"; and test $TTY = "${cfg.loginTTY}"
            exec sway;
        end
      '';
    };
    environment.etc = {
      "sway/config".text = (toString (map (v: mkSwayVariable v) cfg.variables))
        + (toString (map (s: mkSwaySetting s) cfg.settings))
        + (toString (map (w: mkSwayWorkspace w) cfg.workspaces)) + ''
        include /etc/sway/config.d/*
      '';
      "sway/config.d/autostarts".text =
        toString (map (p: mkSwayExec p) cfg.autostarts);
      "sway/config.d/outputs".text =
        toString (map (o: mkSwayOutput o) cfg.outputs);
      "sway/config.d/keybindings".text =
        toString (map (k: mkSwayKeybinding k) cfg.keybindings);
    };
  };
}
