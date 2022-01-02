{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.local.fish;
in
{
  options.local.fish = { enable = mkEnableOption "fish+plus"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ];
    programs = {
      exa = {
        enable = true;
      };
      zoxide = {
        enable = true;
      };

      fish = {
        enable = true;
        functions = {
          startify = {
            body = ''
              set -l pwd (pwd)
              ${pkgs.neovim-remote}/bin/nvr --servername localhost:${toString config.local.neovim.port} --remote-send "<ESC><ESC>:cd $pwd <CR> :Startify <CR>"
            '';
          };
        };
        shellAbbrs = {
          ls = "exa --icons";
          la = "exa --icons --long";
          lg = "exa --icons --git";
          lt = "exa --icons --long  --tree --level=3";
        };
        plugins = [
          {
            name = "snorin";
            src = pkgs.fetchFromGitHub {
              owner = "LastContinue";
              repo = "snorin";
              rev = "bca18944740bc152fcc9beed1e4a28e1ea6b8cfa";
              sha256 = "sha256-XHdwQKTEWOw4rltd/XCTBvX37p9FYxBPeU6J62h2E4E=";
            };
          }
        ];
        interactiveShellInit = ''
          set -l foreground c0caf5
          set -l selection 33467C
          set -l comment 565f89
          set -l red f7768e
          set -l orange ff9e64
          set -l yellow e0af68
          set -l green 9ece6a
          set -l purple 9d7cd8
          set -l cyan 7dcfff
          set -l pink bb9af7

          # Syntax Highlighting Colors
          set -g fish_color_normal $foreground
          set -g fish_color_command $cyan
          set -g fish_color_keyword $pink
          set -g fish_color_quote $yellow
          set -g fish_color_redirection $foreground
          set -g fish_color_end $orange
          set -g fish_color_error $red
          set -g fish_color_param $purple
          set -g fish_color_comment $comment
          set -g fish_color_selection --background=$selection
          set -g fish_color_search_match --background=$selection
          set -g fish_color_operator $green
          set -g fish_color_escape $pink
          set -g fish_color_autosuggestion $comment

          # Completion Pager Colors
          set -g fish_pager_color_progress $comment
          set -g fish_pager_color_prefix $cyan
          set -g fish_pager_color_completion $foreground
          set -g fish_pager_color_description $comment
          set -g snorin_chevrons red green yellow blue magenta cyan white brred brgreen bryellow brblue brmagenta brcyan brwhite


          set -g snorin_random_chevrons 3
          zoxide init fish | source
          direnv hook fish | source
        '';
      };
    };
  };
}
