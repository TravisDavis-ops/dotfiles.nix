{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.mpd-player;
in
{
  options.local.mpd-player = { enable = mkEnableOption "mpd music playere"; };

  config = mkIf cfg.enable {
    programs.ncmpcpp = {
      enable = true;
      bindings = [
        { key = "j"; command = "scroll_down"; }
        { key = "k"; command = "scroll_up"; }
        { key = "J"; command = [ "select_item" "scroll_down" ]; }
        { key = "K"; command = [ "select_item" "scroll_up" ]; }
      ];
      settings = {
        execute_on_song_change = ''notify-send "Playing" "$(mpc --format '%title% - %album%' current)"'';
        visualizer_data_source = "/tmp/mpd.fifo";
        visualizer_output_name = "visualizer";
        visualizer_in_stereo = "yes";
        visualizer_type = "wave";
        visualizer_look = "+|";
      };
    };
  };
}
