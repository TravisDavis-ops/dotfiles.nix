{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.ranger;
in
{
  options.local.ranger = {
    enable = mkEnableOption "Enable ranger";
    enablePreviews = mkEnableOption "Previews";
    enableVcs = mkEnableOption "Vcs";
  };
  config =
    let
      previewConfig = ''
        set preview_images true
        set preview_images_method kitty
      '';
      vcsConfig = ''
        set vcs_aware true
        set vcs_backend_git enabled
        set vcs_msg_length 50
      '';
    in
    mkIf cfg.enable {
      home.packages = with pkgs; [ ranger ];
      xdg.configFile."ranger/rifle.conf" = {
        source = ./rifle.conf;
      };
      xdg.configFile."ranger/rc.conf" = {
        text = ''
          set viewmode miller
          set column_ratios 1,2,2
        '' + (if cfg.enablePreviews then previewConfig else "")
        + (if cfg.enableVcs then vcsConfig else "");
      };
    };

}
