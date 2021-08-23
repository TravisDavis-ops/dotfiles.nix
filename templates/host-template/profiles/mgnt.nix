{ config, pkgs, nur, ... }: {
  imports = [ ];
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
  local = {
    git.enable = true;
  };
}
