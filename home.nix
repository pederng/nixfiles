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
    pkgs.newsboat
    pkgs.zathura
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

  programs.newsboat = {
    enable = true;
    extraConfig = builtins.concatStringsSep "\n" [
      (lib.strings.fileContents ./newsboat.conf)
    ];
    urls = [
      {
        url = "https://this-week-in-rust.org/rss.xml";
        tags = ["rust" "programming"];
      }
      {
        url = "https://haskellweekly.news/newsletter.atom";
        tags = ["haskell" "programming"];
      }
      {
        url = "https://without.boats/blog/index.xml";
        tags = ["rust" "programming"];
      }
      {
        url = "https://rachelbythebay.com/w/atom.xml";
        tags = ["programming"];
      }
      {
        url = "https://www.archlinux.org/feeds/news/";
        tags = ["arch"];
      }
      {
        url = "http://journal.stuffwithstuff.com/rss.xml";
        tags = ["programming"];
      }
      {
        url = "https://drewdevault.com/feed.xml";
        tags = ["programming"];
      }
      {
        url = "https://www.ufried.com/blog/index.xml";
        tags = ["programming"];
      }
      {
        url = "https://github.blog/feed/";
        tags = ["programming"];
      }
      {
        url = "https://hnrss.org/frontpage";
        tags = ["tech" "news"];
      }
      {
        url = "https://www.nrk.no/toppsaker.rss";
        tags = ["news"];
      }
      {
        url = "http://feeds.feedburner.com/nrkbeta";
        tags = ["news"];
      }
      {
        url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCDc1518xgM-E9BklhPYGPKA";
        tags = ["Ihor" "yt"];
      }
    ];
  };

  programs.mpv = {
    enable = true;
    bindings = {
      "l" = "seek 5";
      "h" = "seek -5";
      "j" = "seek -60";
      "k" = "seek 60";
      "S" = "cycle sub";
    };
  };

  xdg.userDirs = {
    enable = true;
    desktop = "$HOME";
    documents = "$HOME/docs";
    download = "$HOME/docs/dl";
    music = "$HOME/docs";
    pictures = "$HOME/docs";
    videos = "$HOME/docs";
    templates = "$HOME/docs";
    publicShare = "$HOME/docs";
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {"binary/octet-stream" = "gvim/desktop";};
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "application/x-extension-html" = "org.qutebrowser.qutebrowser.desktop";
      "image/png" = "sxiv.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    };
  };

  programs.starship = {
    enable = true;
    package = pkgs.starship;
    settings = {
      python = {symbol = " ";};
      rust = {symbol = " ";};
      directory = {fish_style_pwd_dir_length = 1;};
      kubernetes = {disabled = true;};

      aws = {disabled = true;};
    };
  };

  programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser;
    keyMappings = {
      "<Ctrl-[>" = "<Escape>";
      "<Ctrl-6>" = "<Ctrl-^>";
      "<Ctrl-M>" = "<Return>";
      "<Shift-Return>" = "<Return>";
      "<Enter>" = "<Return>";
      "<Shift-Enter>" = "<Return>";
      "<Ctrl-Enter>" = "<Ctrl-Return>";
    };
    settings = {
      completion.cmd_history_max_items = 100;
      content.webgl = false;
      fonts.completion.category = "bold 10pt monospace";
      fonts.completion.entry = "10pt monospace";
      fonts.debug_console = "10pt monospace";
      fonts.downloads = "10pt monospace";
      fonts.hints = "bold 10pt monospace";
      fonts.keyhint = "10pt monospace";
      fonts.messages.error = "10pt monospace";
      fonts.messages.info = "10pt monospace";
      fonts.messages.warning = "10pt monospace";
      fonts.default_family = [
        "DejaVu Sans Mono"
        "Hack Nerd Font Mono"
        "xos4 Terminus"
        "Terminus"
        "Monospace"
        "Monaco"
        "Bitstream Vera Sans Mono"
        "Andale Mono"
        "Courier New"
        "Courier"
        "Liberation Mono"
        "monospace"
        "Fixed"
        "Consolas"
        "Terminal"
      ];
      fonts.prompts = "10pt sans-serif";
      fonts.statusbar = "10pt monospace";
      # fonts.tabs = "10pt monospace";
      tabs.position = "left";
      tabs.width = "10%";
    };
    extraConfig = "
try:
    import custom_config
    c.zoom.default = custom_config.ZOOM
except (ImportError, AttributeError):
    c.zoom.default = '100%'
config.bind(' <Ctrl-K> ', ' completion-item-focus prev ', mode=' command ')
config.bind(' <Ctrl-J> ', ' completion-item-focus next ', mode=' command ')
";
    searchEngines = {
      "DEFAULT" = "https://duck.com/?q={}";
    };
  };

  home.file.".config/dunstrc".source = ./dunstrc;
  home.file.".config/npm/npmrc".source = ./npmrc;
  home.file.".config/ctags/excludes.ctags".source = ./excludes.ctags;
  home.file.".config/python/startup.py".source = ./python.vim;
  home.file.".config/X11/xcolors".source = ./xcolors;
  home.file.".config/X11/xinitrc".source = ./xinitrc;
  home.file.".config/X11/xresources_template".source = ./xresources_template;
  home.file.".config/base16-hooks/update-xresources".source = ./update-xresources;
  home.file.".config/fontconfig/fonts.conf".source = ./fonts.conf;
  home.file.".config/isync/mbsyncrc".source = ./mbsyncrc;
  home.file.".config/msmtp/config".source = ./msmtp_config;
  home.file.".config/mutt/bindings".source = ./bindings;
  home.file.".config/mutt/colors".source = ./colors;
  home.file.".config/mutt/gmail-personal".source = ./gmail-personal;
  home.file.".config/mutt/gmail-tsl".source = ./gmail-tsl;
  home.file.".config/mutt/gpg.rc".source = ./gpg.rc;
  home.file.".config/mutt/mailcap".source = ./mailcap;
  home.file.".config/mutt/muttrc".source = ./muttrc;
  home.file.".config/mutt/purelymail".source = ./purelymail;
  home.file.".config/mutt/sidebar".source = ./sidebar;
  home.file.".config/systemd/user/mbsync.service".source = ./mbsync.service;
  home.file.".config/systemd/user/mbsync.timer".source = ./mbsync.timer;
}
