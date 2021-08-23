{ config, pkgs, nur, ... }: {
  imports = [ ../modules/users ];
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
  home.packages = [ nur.cocogitto ];
  local = {
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
