{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.ranger;
  helpers = import ./helpers.nix;
in
with helpers; {
  options.local.ranger = {
    enable = mkOption {
      description = "Enable Ranger";
      type = types.bool;
      default = false;
    };
    enablePreviews = mkEnableOption "Previews";
    enableVcs = mkEnableOption "Vcs";

    fileRules = mkOption {
      description = " rifle.conf ";
      type = with types; (listOf (attrsOf anything));
      default = [{
        extension = "nix";
        command = "nvim";
        args = [ "$@" ];
      }];
    };

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
        text = toString (map (r: mkFileRule r) cfg.fileRules);
        executable = false;
      };
      xdg.configFile."ranger/rc.conf" = {
        text = ''
          set viewmode miller
          set column_ratios 1,2,2
        '' + (if cfg.enablePreviews then previewConfig else "")
        + (if cfg.enableVcs then vcsConfig else "");
        executable = false;
      };
    };

}
