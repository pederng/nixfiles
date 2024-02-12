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
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.joypixels.acceptLicense = true;
  home.username = "peder";
  home.homeDirectory = "/home/peder";
  home.packages = with pkgs; [
    abook
    acpi
    ast-grep
    awscli2
    azure-cli
    bat
    bitwarden-cli
    btop
    ctags
    difftastic
    dmenu
    dunst
    entr
    fastmod
    fd
    feh
    go
    hadolint
    handlr
    helmfile
    joypixels
    jq
    k9s
    kind
    kubectl
    kubectx
    kubelogin
    kubernetes-helm
    libnotify
    linkerd
    lsof
    lynx
    mkcert
    neomutt
    nerdfonts
    newsboat
    nodePackages.bash-language-server
    nodePackages.npm
    nodejs
    notmuch
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    pass
    pinentry-qt
    popeye
    powertop
    ps_mem
    readline
    ripgrep
    rsync
    scrot
    shellcheck
    skaffold
    sops
    spotify
    step-cli
    stern
    strace
    stylua
    sxiv
    terraform
    terraform-ls
    tokei
    toot
    tree
    trivy
    units
    unzip
    urlscan
    viddy
    wget
    xbanish
    xbindkeys
    xclip
    xdg-utils
    xh
    xss-lock
    yq
    yt-dlp
    zathura
    zk
  ];
  manual.manpages.enable = false;
  home.stateVersion = "23.05";
  home.sessionVariables = {
    LD_LIBRARY_PATH = "";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    profileExtra = lib.strings.fileContents ./zsh/zprofile;
    syntaxHighlighting.enable = true;
    initExtra = builtins.concatStringsSep "\n" [
      ''
        ${lib.strings.fileContents ./zsh/zshrc}
        ${lib.strings.fileContents ./zsh/aliases.zsh}
        ${lib.strings.fileContents ./zsh/functions.zsh}
      ''
    ];
    history = {
      path = "$ZDOTDIR/zsh/histfile";
    };
    defaultKeymap = "viins";
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
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
      tree-sitter
      rnix-lsp
      statix
      alejandra
      sumneko-lua-language-server
    ];
  };
  home.file.".config/nvim/after/syntax/python.vim".source = ./nvim/python.vim;
  home.file.".config/nvim/after/syntax/markdown.vim".source = ./nvim/markdown.vim;
  # home.file.".config/nvim/queries/python/injections.scm".source = ./nvim/injections.scm;

  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    extraConfig = builtins.concatStringsSep "\n" [
      (lib.strings.fileContents ./tmux.conf)
    ];
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-alphabet qwerty-homerow
          set -g @thumbs-bg-color blue
          set -g @thumbs-fg-color green
          set -g @thumbs-hint-bg-color black
          set -g @thumbs-hint-fg-color yellow
        '';
      }
      {
        plugin = tmuxPlugins.tmux-fzf;
        extraConfig = ''
          bind w choose-tree -Z
        '';
      }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type d";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
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
      st = "status";
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
    difftastic = {
      enable = true;
      background = "dark";
      color = "always";
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
      "*_null-ls*"
      "*.null-ls*"
      ".envrc"
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
      web.browser = "firefox";
      pull.rebase = false;
      diff.algorithm = "histogram";
    };
  };

  programs.gh = {
    enable = true;
    extensions = [
      pkgs.gh-dash
    ];
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

  programs.starship = {
    enable = true;
    package = pkgs.starship;
    settings = {
      python = {symbol = " ";};
      rust = {symbol = " ";};
      directory = {fish_style_pwd_dir_length = 1;};
      kubernetes = {
        disabled = false;
        format = "[$context](blue)[\(:$namespace\)](dimmed green) ";
        contexts = [
          {
            context_pattern = "kind-coffer-dev";
            context_alias = "dev";
          }
          {
            context_pattern = "coffer-test-aks";
            context_alias = "test";
          }
          {
            context_pattern = "coffer-prod-dora";
            context_alias = "prod";
          }
        ];
      };

      aws = {disabled = true;};
    };
  };

  xdg = {
    userDirs = {
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

    mimeApps = {
      enable = true;
      associations.added = {"binary/octet-stream" = "gvim/desktop";};
      defaultApplications = {
        "application/pdf" = "zathura.desktop";
        "application/x-extension-html" = "org.qutebrowser.qutebrowser.desktop";
        "image/png" = "sxiv.desktop";
        "text/html" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      };
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
    ".config/vim/vimrc_background".source = ./vimrc_background;
    ".config/qutebrowser/config.py".source = ./qutebrowser_config.py;
    ".config/notmuch/notmuchrc".source = ./notmuchrc;
    ".config/jj/config.toml".source = ./jjconfig.toml;

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

    ".local/share/gnupg/gpg-agent.conf".text = ''
      default-cache-ttl 86400
      max-cache-ttl 86400
      pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt
      enable-ssh-support
    '';
    ".local/share/gnupg/peder.galteland.pem".source = ./peder.galteland.pem;
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };
  fonts.fontconfig.enable = true;
}
