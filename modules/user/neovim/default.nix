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
    enable = mkEnableOption "Enable Neovim";

    # qol plugin set
    enableQol = mkEnableOption "Enable quailty of life plugins";

    # Cxx plugin set
    enableC99 = mkEnableOption "Enable C99 related plugins";

    # Nix plugin set
    enableNix = mkEnableOption "Enable Nix related plugins";

    # Rust plugin set
    enableRust = mkEnableOption "Enable Rust related plugins";

    # Python plugin set
    enablePython = mkEnableOption "Enable Python related plugins";

    # Gui configuration
    enableGui = mkEnableOption "Enable Neovide as a frontend to neovim";

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
        ${pkgs.neovim}/bin/nvim -n --headless --listen localhost:${toString cfg.port}
      '';
      neovide-editor = pkgs.writeShellScriptBin "neovide-editor" ''
        ${pkgs.neovide}/bin/neovide --nofork --wayland-app-id neovide-editor $@
      '';

      neovide-client = pkgs.writeShellScriptBin "neovide-client" ''
        ${pkgs.neovide}/bin/neovide --remote-tcp localhost:${toString cfg.port} --wayland-app-id neovide-client $@
      '';

      open-remotely = pkgs.writeShellScriptBin "open-remotely" ''
        source /etc/profile
        notify-send Opening "in neovide";
        if  [ -z "$(pgrep -af neovide-server)" ]
          then
            systemctl --user restart neovim.service
            ${neovide-client}/bin/neovide-client
          else
            ${neovide-client}/bin/neovide-client
        fi
        ${pkgs.neovim-remote}/bin/nvr --servername localhost:${toString cfg.port} --remote $@;
      '';

      nvr-safe = pkgs.writeShellScriptBin "nvr-safe" ''
        ${pkgs.neovim-remote}/bin/nvr --servername localhost:${toString cfg.port} --remote-send "<ESC><ESC>"
        ${pkgs.neovim-remote}/bin/nvr --servername localhost:${toString cfg.port} $@
      '';
    in
    {
      home.sessionVariables = {
        REMOTE = if cfg.enableGui then ''${open-remotely}/bin/open-remotely'' else "nvim";
        VISUAL = if cfg.enableGui then ''${neovide-editor}/bin/neovide-editor'' else "nvim";
        EDITOR = "nvim";
      };

      home.packages = baseDeps ++ (if cfg.enableQol then qolDeps else [ ])
        ++ (if cfg.enableGui then [ nvr-safe pkgs.neovide neovide-server open-remotely neovide-editor neovide-client ] else [ ])
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
