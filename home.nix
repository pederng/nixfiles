{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];
  home.username = "peder";
  home.homeDirectory = "/home/peder";
  home.packages = [
    pkgs.tmux
    pkgs.neovim-nightly
    pkgs.stylua
    pkgs.alejandra
    pkgs.rnix-lsp
    pkgs.sumneko-lua-language-server
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/nvim/lua/plugins.lua".source = ./plugins.lua;
  home.file.".config/nvim/lua/colors.lua".source = ./colors.lua;
  home.file.".config/nvim/lua/options.lua".source = ./options.lua;
  home.file.".config/nvim/lua/bindings.lua".source = ./bindings.lua;
  home.file.".config/nvim/lua/autocmds.lua".source = ./autocmds.lua;
  home.file.".config/nvim/lua/commands.lua".source = ./commands.lua;

  programs.git = {
    enable = true;
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
}
