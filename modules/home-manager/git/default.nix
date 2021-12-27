{ pkgs, config, lib, ... }:
with lib;
let cfg = config.local.git;

in
{
  options.local.git = {
    enable = mkOption {
      description = "Enable Git";
      type = types.bool;
      default = false;
    };

    enableStore = mkOption {
      description = "Enable Credential Storage";
      type = types.bool;
      default = false;
    };

    userName = mkOption {
      description = "Your Username";
      type = types.str;
      default = "nobody";
    };

    userEmail = mkOption {
      description = "Your Email";
      type = types.str;
      default = "nobody@test.com";
    };
  };

  config = mkIf (cfg.enable) {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      extraConfig = mkIf (cfg.enableStore) { credential.helper = "store"; };
    };
  };
}
