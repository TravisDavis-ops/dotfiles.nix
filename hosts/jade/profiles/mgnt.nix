{ config, pkgs, ... }: {
  imports = [ ];
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs = {
    htop = {
      enable = true;
    };
  };
  local = {
    git = {
      enable = true;
      enableStore = true;
      userName = "travisdavis-ops";
      userEmail = "travisdavismedia@gmail.com";
    };
    neovim = {
      enable = true;
      enableQol = true;
      enableRust = true;
      enablePython = true;
      enableNix = true;
    };
    ranger = {
      enable = true;
      enablePreviews = true;
      enableVcs = true;
    };
  };
}
