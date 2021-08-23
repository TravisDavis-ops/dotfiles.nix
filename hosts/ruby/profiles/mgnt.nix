{ config, pkgs, ... }: {
  imports = [ ];
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
  programs = {
    htop = {
      enable = true;
      settings = {
        delay = 15;
        fields = with config.lib.htop.fields; [
          PID
          USER
          STATE
          PERCENT_CPU
          PERCENT_MEM
          TIME
        ];
        highlight_base_name = 1;
        highlight_threads = 1;
      } // (with config.lib.htop;
        leftMeters [ (bar "AllCPUs2") (bar "Memory") ]);
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
