{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.neovim;

  basePlugins = with pkgs.vimPlugins; [
    coc-nvim
    vim-startify
    syntastic
    lightline-vim
    vim-lightline-coc
    tokyonight-nvim
  ];

  baseDeps = with pkgs; [ ];

  qolPlugins = with pkgs.vimPlugins; [ ranger-vim fzf-vim fugitive ];
  qolDeps = with pkgs; [ ranger fzf git ];

  nixPlugins = with pkgs.vimPlugins; [ vim-nix ];
  nixDeps = with pkgs; [ rnix-lsp ];

  rustPlugins = with pkgs.vimPlugins; [ coc-rust-analyzer vim-toml ];
  rustDeps = with pkgs; [ rust-analyzer rustc cargo ];

  pythonPlugins = with pkgs.vimPlugins; [ coc-pyright ];
  pythonDeps = with pkgs; [ python310 ];

  c99Plugins = with pkgs.vimPlugins; [ ];
  c99Deps = with pkgs; [ ccls bear ];

  defaultConfig = lib.readFile ./init.vim;
in
with builtins;  {
  options.local.neovim = {
    enable = mkEnableOption "neovim";

    # qol plugin set
    enableQol = mkEnableOption "quailty of life plugins";

    # Cxx plugin set
    enableC99 = mkEnableOption "Cxx related plugins";

    # Nix plugin set
    enableNix = mkEnableOption "nix related plugins";

    # Rust plugin set
    enableRust = mkEnableOption "rust related plugins";

    # Python plugin set
    enablePython = mkEnableOption "python related plugins";

    # Gui configuration
    enableGui = mkEnableOption "neovide frontend";

    port = mkOption {
      type = types.port;
      default = 8096;
    };

    # More configurations
    extraConfig = mkOption {
      description = "Append additonal configuration";
      type = types.str;
      default = "";
    };
  };

  config = mkIf (cfg.enable) (
    let
      neovide-server = pkgs.writeShellScriptBin "neovide-server" ''
        source /etc/profile
        notify-send "Starting Server";
        ${pkgs.neovim}/bin/nvim -n --headless --listen localhost:${toString cfg.port}
      '';

      neovide-client = pkgs.writeShellScriptBin "neovide-client" ''
        if [ -z "$(pgrep -af neovide-client)" ]
          then
            ${pkgs.neovide}/bin/neovide --remote-tcp localhost:${toString cfg.port} --wayland-app-id neovide-client
          else
            notify-send "Focusing Client";
            ${pkgs.sway}/bin/swaymsg "[con_mark=client]" focus
        fi
      '';

      open-remote = pkgs.writeShellScriptBin "open-remote" ''
        source /etc/profile
        if [ -z "$(pgrep -af neovide-server)" ]
          then
            systemctl --user restart neovim.service;
        fi
        ${pkgs.neovim-remote}/bin/nvr --nostart --servername localhost:${toString cfg.port} $@
        source ${neovide-client}/bin/neovide-client;
      '';

      nvr-safe = pkgs.writeShellScriptBin "nvr-safe" ''
        ${pkgs.neovim-remote}/bin/nvr --nostart --servername localhost:${toString cfg.port} -cc "<ESC>" -c "<CR>" $@
      '';
    in
    {
      home.sessionVariables = {
        NVIM_REMOTE = if cfg.enableGui then ''${open-remote}/bin/open-remote'' else "nvim";
        NVIM_SEND = if cfg.enableGui then ''${nvr-safe}/bin/nvr-safe'' else "nvim";
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      home.packages = baseDeps ++ (if cfg.enableQol then qolDeps else [ ])
        ++ (if cfg.enableGui then [ nvr-safe pkgs.neovide neovide-server open-remote neovide-client ] else [ ])
        ++ (if cfg.enableNix then nixDeps else [ ])
        ++ (if cfg.enableRust then rustDeps else [ ])
        ++ (if cfg.enableC99 then c99Deps else [ ])
        ++ (if cfg.enablePython then pythonDeps else [ ]);

      systemd.user.services.neovide = mkIf cfg.enableGui {
        Unit = {
          Description = "neovide server";
          After = [ "default.target" ];
        };
        Install = { WantedBy = [ "basic.target" ]; };
        Service = {
          ExecStart = "${neovide-server}/bin/neovide-server";

          Restart = "always";
          KillMode = "control-group";
        };
      };

      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        coc.enable = true; # do I need the plugin version
        coc.settings = {
          languageserver = {
            ccls = mkIf cfg.enableC99 {
              command = "ccls";
              filetypes = [ "c" "cpp" "objc" "objcpp" ];
              rootPatterns = [ ".ccls" "compile_commands.json" ".vim/" ".git/" ".hg/" ];
              initializationOptions = {
                cache = {
                  directory = "/tmp/ccls";
                };
              };
            };
            nix = mkIf cfg.enableNix {
              command = "rnix-lsp";
              rootPatterns = [ "flake.nix" "default.nix" "shell.nix" ".git/" ]; # these might make sence
              filetypes = [ "nix" ];
            };

          };
        };
        withPython3 = true;
        extraConfig = builtins.concatStringsSep "\n" [
          defaultConfig
          cfg.extraConfig
          "let g:coc_node_path = '${pkgs.nodejs}/bin/node'"
        ];
        plugins = basePlugins ++ (if cfg.enableQol then qolPlugins else [ ])
          ++ (if cfg.enableNix then nixPlugins else [ ])
          ++ (if cfg.enableRust then rustPlugins else [ ])
          ++ (if cfg.enableC99 then c99Plugins else [ ])
          ++ (if cfg.enablePython then pythonPlugins else [ ]);
      };
    }
  );
}
