{ nix, nur, builders, ... }:
with builders;
mkProfile {
  username = "tod";
  packages = (with nur; [
    one-step-from-eden
    torchlight
    stardew-valley
    swayhide
    nhentai
    cocogitto
  ]) ++ (with nix; [ discord mupdf obsidian pcalc sxiv bpytop sysstat ]);
  userConfig = {
    git = {
      enable = true;
      enableStore = true;
      userName = "travisdavis-ops";
      userEmail = "travisdavismedia@gmail.com";
    };
    sway = { enable = true; };
    waybar.enable = true;
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
