{ nix, nur, builders, ... }:
with builders;
mkProfile {
  username = "tod";
  packages = (with nur; [
    cocogitto
  ]) ++ (with nix; [ pcalc bpytop ]);
  userConfig = {
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
