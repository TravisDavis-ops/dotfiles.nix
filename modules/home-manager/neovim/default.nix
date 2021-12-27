{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.neovim;

  basePlugins = with pkgs.vimPlugins; [
    coc-nvim
    syntastic
    fugitive
    vim-airline
    vim-startify
  ];
  baseDeps = with pkgs; [ ];

  fullPlugins = with pkgs.vimPlugins; [ ranger-vim fzf-vim ];
  fullDeps = with pkgs; [ ranger fzf ];

  nixPlugins = with pkgs.vimPlugins; [ vim-nix ];
  nixDeps = with pkgs; [ ];

  rustPlugins = with pkgs.vimPlugins; [ coc-rust-analyzer vim-toml ];
  rustDeps = with pkgs; [ rust-analyzer rustc cargo ];

  pythonPlugins = with pkgs.vimPlugins; [ coc-pyright ];
  pythonDeps = with pkgs; [ python310 ];

  c98Plugins = with pkgs.vimPlugins; [ ];
  c98Deps = with pkgs; [ ccls ];

  defaultConfig = lib.readFile ./init.vim;
in
{
  options.local.neovim = {

    enable = mkEnableOption "Enable Neovim";

    # Heavier plugin set
    enableFull = mkEnableOption "Enable slow/large plugins";

    enableC98 = mkEnableOption "Enable c98 related plugins";

    # Nix plugin set
    enableNix = mkOption {
      description = "Enable Nix Plugins";
      type = types.bool;
      default = false;
    };

    # Rust plugin set
    enableRust = mkOption {
      description = "Enable Rust Plugins";
      type = types.bool;
      default = false;
    };

    # Python plugin set
    enablePython = mkOption {
      description = "Enable Rust Plugins";
      type = types.bool;
      default = false;
    };

    # More configurations
    extraConfig = mkOption {
      description = "Append additonal configuration";
      type = types.str;
      default = "";
    };

  };
  config = mkIf (cfg.enable) {
    home.packages = baseDeps ++ (if cfg.enableFull then fullDeps else [ ])
      ++ (if cfg.enableNix then nixDeps else [ ])
      ++ (if cfg.enableRust then rustDeps else [ ])
      ++ (if cfg.enableC98 then c98Deps else [ ])
      ++ (if cfg.enablePython then pythonDeps else [ ]);

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      coc.enable = true;
      coc.settings = {
        languageserver = {
          ccls = {
            command = "ccls";
            filetypes = [ "c" "cpp" "objc" "objcpp" ];
            rootPatterns = [ ".ccls" "compile_commands.json" ".vim/" ".git/" ".hg/" ];
            initializationOptions = {
              cache = {
                directory = "/tmp/ccls";
              };
            };
          };
        };
      };
      withPython3 = true;
      extraConfig = defaultConfig + "\n" + cfg.extraConfig;
      plugins = basePlugins ++ (if cfg.enableFull then fullPlugins else [ ])
        ++ (if cfg.enableNix then nixPlugins else [ ])
        ++ (if cfg.enableRust then rustPlugins else [ ])
        ++ (if cfg.enableC98 then c98Plugins else [ ])
        ++ (if cfg.enablePython then pythonPlugins else [ ]);
    };
  };
}
