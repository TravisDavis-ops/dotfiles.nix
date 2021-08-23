{
  enable = true;
  enableFishLaunch = true;
  loginTTY = "/dev/tty1";
  variables = [
    {
      name = "$meta";
      value = "Mod4";
    }
    {
      name = "$alt";
      value = "Mod1";
    }
    {
      name = "$term";
      value = "kitty";
    }
    {
      name = "$menu";
      value = "wofi --show run";
    }
  ];
  settings = [
    {
      key = "default_border";
      value = "pixel 3px";
    }
    {
      key = "focus_follows_mouse";
      value = "yes";
    }
    {
      key = "focus_wrapping";
      value = "no";
    }
    {
      key = "floating_modifier";
      value = "$alt";
    }
  ];
  workspaces = [
    {
      name = "1";
      output = "DP-1";
    }
    {
      name = "2";
      output = "DP-1";
    }
    {
      name = "3";
      output = "DP-1";
    }
    {
      name = "4";
      output = "DP-2";
    }
    {
      name = "5";
      output = "DP-2";
    }
    {
      name = "6";
      output = "DP-2";
    }
  ];
  outputs = [
    {
      name = "DP-1";
      mode = "1920x1080@60Hz";
      position = [ 0 1080 ];
    }
    {
      name = "DP-2";
      mode = "1920x1080@60Hz";
      position = [ 0 0 ];
    }
  ];
  autostarts = [
    { program = "autotiling"; }
    { program = "pulseaudio"; }
    {
      program = "wl-paste";
      args = [ "-p" "-t text" "--watch clipman" "store" "-P" "--" ];
    }
    {
      program = "inactive-window-transparency.py";
      args = [ "--opacity 0.50" "&" ];
    }
  ];

  keybindings = [
    {
      combo = "$alt+Shift+q";
      action = "kill";
    }
    {
      combo = "$alt+Shift+r";
      action = "reload";
    }
    # Teminal 
    {
      combo = "$alt+Return";
      action = "exec $term";
    }
    # Locker
    {
      combo = "$meta+l";
      action = "exec swaylock";
    }
    # Application Launcher
    {
      combo = "$alt+p";
      action = "exec $menu";
    }
    {
      combo = "$meta+r";
      action = "exec $menu";
    }
    # Program Launcher 
    {
      combo = "$alt+Shift+p";
      action = "exec dmenu_run";
    }
    {
      combo = "$meta+Shift+r";
      action = "exec dmenu_run";
    }
    # File Manager 
    {
      combo = "$meta+e";
      action = "exec $term ranger";
    }
    # Fullscreen
    {
      combo = "$alt+f";
      action = "fullscreen";
    }
    # Floating
    {
      combo = "$alt+Shift+f";
      action = "floating toggle";
    }
    {
      combo = "$alt+Space";
      action = "focus floating";
    }
    # Switching
    {
      combo = "$alt+Tab";
      action = "workspace next";
    }
    {
      combo = "$alt+Shift+Tab";
      action = "workspace prev";
    }
    # Monitor 1
    {
      combo = "$alt+u";
      action = "workspace 1";
    }
    {
      combo = "$alt+i";
      action = "workspace 2";
    }
    {
      combo = "$alt+o";
      action = "workspace 3";
    }
    {
      combo = "$alt+Shift+u";
      action = "move container to workspace 1";
    }
    {
      combo = "$alt+Shift+i";
      action = "move container to workspace 2";
    }
    {
      combo = "$alt+Shift+o";
      action = "move container to workspace 3";
    }
    # Monitor 2
    {
      combo = "$meta+u";
      action = "workspace 4";
    }
    {
      combo = "$meta+i";
      action = "workspace 5";
    }
    {
      combo = "$meta+o";
      action = "workspace 6";
    }
    {
      combo = "$meta+Shift+u";
      action = "move container to workspace 4";
    }
    {
      combo = "$meta+Shift+i";
      action = "move container to workspace 5";
    }
    {
      combo = "$meta+Shift+o";
      action = "move container to workspace 6";
    }
    # Scratchpad
    {
      combo = "$alt+Shift+Backspace";
      action = " move scratchpad";
    }
    {
      combo = "$alt+Backspace";
      action = " scratchpad show";
    }
    # Focus
    {
      combo = "$alt+h";
      action = "focus left";
    }
    {
      combo = "$alt+j";
      action = "focus down";
    }
    {
      combo = "$alt+k";
      action = "focus up";
    }
    {
      combo = "$alt+l";
      action = "focus right";
    }
    # Move
    {
      combo = "$alt+Shift+h";
      action = "move left";
    }
    {
      combo = "$alt+Shift+j";
      action = "move down";
    }
    {
      combo = "$alt+Shift+k";
      action = "move up";
    }
    {
      combo = "$alt+Shift+l";
      action = "move right";
    }
    # Resize
    {
      combo = "$alt+Ctrl+h";
      action = "resize shrink width 32 px or 32 ppt";
    }
    {
      combo = "$alt+Ctrl+j";
      action = "resize grow height 32 px or 32 ppt";
    }
    {
      combo = "$alt+Ctrl+k";
      action = "resize shrink height 32 px or 32 ppt";
    }
    {
      combo = "$alt+Ctrl+l";
      action = "resize grow width 32 px or 32 ppt";
    }
  ];
}
