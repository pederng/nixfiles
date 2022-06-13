{
  config,
  pkgs,
  lib,
  ...
}: let
  pluginGit = repo:
    pkgs.vimUtils.buildVimPlugin {
      name = repo;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}";
        ref = "HEAD";
      };
    };
in {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];
  home.username = "peder";
  home.homeDirectory = "/home/peder";
  home.packages = [
    pkgs.dunst
  ];
  home.stateVersion = "21.11";

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        lua << EOF
        ${lib.strings.fileContents ./plugins.lua}
        ${lib.strings.fileContents ./colors.lua}
        ${lib.strings.fileContents ./options.lua}
        ${lib.strings.fileContents ./bindings.lua}
        ${lib.strings.fileContents ./autocmds.lua}
        ${lib.strings.fileContents ./commands.lua}
        EOF
      ''
    ];
    extraPackages = with pkgs; [
      rnix-lsp
      statix
      stylua
      alejandra
      sumneko-lua-language-server
    ];
    plugins = with pkgs.vimPlugins; [
      bufferline-nvim
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      gitsigns-nvim
      glow-nvim
      lsp-colors-nvim
      lsp_signature-nvim
      lspkind-nvim
      lualine-nvim
      neoscroll-nvim
      null-ls-nvim
      nvim-base16
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter
      nvim-treesitter-context
      nvim-web-devicons
      octo-nvim
      plenary-nvim
      telescope-nvim
      todo-comments-nvim
      trouble-nvim
      vim-beancount
      vim-better-whitespace
      vim-commentary
      vim-cue
      vim-dadbod
      vim-fugitive
      vim-indent-object
      vim-polyglot
      vim-repeat
      vim-rhubarb
      vim-rsi
      vim-speeddating
      vim-surround
      vim-textobj-entire
      vim-textobj-user
      vim-tmux-navigator
      vim-unimpaired
      vim-vinegar

      (pluginGit "lewis6991/hover.nvim")
      (pluginGit "christoomey/vim-system-copy")
      (pluginGit "kana/vim-textobj-indent")
      (pluginGit "kana/vim-textobj-line")
      (pluginGit "pedernot/vim-textobj-python")
    ];
  };
  home.file.".config/nvim/after/syntax/python.vim".source = ./python.vim;
  home.file.".config/nvim/after/syntax/markdown.vim".source = ./markdown.vim;

  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    extraConfig = builtins.concatStringsSep "\n" [
      (lib.strings.fileContents ./tmux.conf)
    ];
  };

  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Peder Notto Galteland";
    userEmail = "peder.galteland@softwarelab.no";
    aliases = {
      a = "add";
      b = "branch";
      co = "checkout";
      c = "commit";
      ss = "status -sb";
      s = "status";
      graph = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
      oneline = "log --pretty=oneline";
      mergelog = "log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --merges";
      amend = "commit --amend -C HEAD";
      listfiles = "diff-tree --no-commit-id --name-only -r";
      stash-all = "stash save --include-untracked";
      files = "!git diff --name-only $(git merge-base HEAD master)";
      stat = "!git diff --stat $(git merge-base HEAD master)";
      compare = "diff master...HEAD";
    };
    delta = {
      enable = true;
      options = {
        theme = "Monokai Extended";
      };
    };
    ignores = [
      "tags"
      "tags.lock"
      "*.swp"
      "*.bak"
      "*.swo"
      ".ropeproject"
      "*peder*"
      "pytest.ini"
      "profile"
      "callgraph.dot"
      "__pycache__"
      ".bash_history"
      "pylint-error.xml"
      ".mypy_cache"
      ".jira.d"
      ".pytest_cache"
      ".hypothesis"
      ".sqlfluff"
    ];
    extraConfig = {
      user.signingKey = "4980821A221FE5B1";
      interactive.colorMoved = "default";
      push.default = "current";
      commit.gpgsign = true;
      status.showUntrackedFiles = "all";
      "remote \"origin\"".prune = true;
      "mergetool \"nvim\"".cmd = "nvim -f -c \"Gdiffsplit!\" \"$MERGED\"";
      merge = {
        tool = "nvim";
        conflictstyle = "zdiff3";
      };
      mergetool.keepBackup = false;
      web.browser = "qb";
      "browser \"qb\"".cmd = "qutebrowser";
      pull.rebase = false;
      diff.algorithm = "histogram";
    };
  };

  home.file.".config/dunstrc".source = ./dunstrc;
}
