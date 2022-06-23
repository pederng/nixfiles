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
  home.packages = with pkgs; [
    dunst
    newsboat
    zathura
    vale
    shellcheck
    viddy
    hadolint
    trivy
    zsh
    ripgrep
    fd
    exa
    entr
    docker-compose
    firefox
    python39
    xh
    zoxide
    ctags
    dmenu
    gh
    handlr
    qutebrowser
    units
  ];
  home.stateVersion = "22.05";
  home.sessionVariables = {
    LD_LIBRARY_PATH = "";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    profileExtra = lib.strings.fileContents ./zsh/zprofile;
    initExtra = builtins.concatStringsSep "\n" [
      ''
        ${lib.strings.fileContents ./zsh/zshrc}
        ${lib.strings.fileContents ./zsh/aliases}
        ${lib.strings.fileContents ./zsh/functions}
      ''
    ];
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        lua << EOF
        ${lib.strings.fileContents ./nvim/plugins.lua}
        ${lib.strings.fileContents ./nvim/colors.lua}
        ${lib.strings.fileContents ./nvim/options.lua}
        ${lib.strings.fileContents ./nvim/bindings.lua}
        ${lib.strings.fileContents ./nvim/autocmds.lua}
        ${lib.strings.fileContents ./nvim/commands.lua}
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
    # extraConfig = "
    # try:
    # import custom_config
    # c.zoom.default = custom_config.ZOOM
    # except (ImportError, AttributeError):
    # c.zoom.default = '100%'
    # config.bind(' <Ctrl-K> ', ' completion-item-focus prev ', mode=' command ')
    # config.bind(' <Ctrl-J> ', ' completion-item-focus next ', mode=' command ')
    # ";
    searchEngines = {
      "DEFAULT" = "https://duck.com/?q={}";
    };
  };

  home.file = {
    ".config/dunstrc".source = ./dunstrc;
    ".config/npm/npmrc".source = ./npmrc;
    ".config/ctags/excludes.ctags".source = ./excludes.ctags;
    ".config/python/startup.py".source = ./startup.py;
    ".config/base16-hooks/update-xresources".source = ./update-xresources;
    ".config/fontconfig/fonts.conf".source = ./fonts.conf;
    ".config/isync/mbsyncrc".source = ./mbsyncrc;
    ".config/msmtp/config".source = ./msmtp_config;

    ".config/mutt" = {
      source = ./mutt;
      recursive = true;
    };

    ".config/X11" = {
      source = ./X11;
      recursive = true;
    };

    ".config/systemd/user/" = {
      source = ./systemd;
      recursive = true;
    };

    ".local/share/gnupg/gpg-agent.conf".source = ./gpg-agent.conf;
    ".local/share/gnupg/peder.galteland.pem".source = ./peder.galteland.pem;
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };
}
