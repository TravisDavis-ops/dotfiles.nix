{ config, pkgs, lib, ... }:
with lib;
let cfg = config.os.p.mpd;
in
{
  options.os.p.mpd = {
    enable = mkOption {
      description = "Enable MPD";
      type = types.bool;
      default = false;
    };
    musicPath = mkOption {
      description = "the path to your music directory";
      type = types.path;
      default = "/mnt/Music";
    };
    pulseFix = mkEnableOption "Enable MPD to connect to local sound server";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mpc_cli ];
    services.mpd = {
      enable = true;
      extraConfig = mkIf cfg.pulseFix ''
        audio_output {
          type "pulse"
          name "Pulseaudio"
          server "127.0.0.1" # MPD must connect to the local sound server
        }
        audio_output {
            type "fifo"
            name "visualizer"
            path "/tmp/mpd.fifo"
            format "44100:16:2"
        }
      '';
      musicDirectory = cfg.musicPath;
    };
  };
}
