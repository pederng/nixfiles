
{
  config,
  pkgs,
  lib,
  ...
}: {
  # nixpkgs = {
  #   overlays = [
  #     inputs.neovim-nightly-overlay.overlays.default
  #   ];
  # };

  programs = {
    home-manager.enable = true;

    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      profileExtra = lib.strings.fileContents ./zsh/zprofile;
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
      syntaxHighlighting.enable = true;
      initContent = builtins.concatStringsSep "\n" [
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

    password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
      };
    };

    ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "asbest" = {
          hostname = "bk.cptr.no";
        };
        "bast1" = {
          hostname = "dora.cptr.no";
          port = 2233;
          proxyCommand = "ssh -q -W %h:%p asbest";
        };
        "bast2" = {
          hostname = "dora.cptr.no";
          port = 2234;
          proxyCommand = "ssh -q -W %h:%p asbest";
        };
        "staging" = {
          hostname = "app9";
          proxyCommand = "ssh -q -W %h:%p bast1";
        };
        "app*" = {
          proxyCommand = "ssh -q -W %h:%p bast1";
        };
        "util1" = {
          proxyCommand = "ssh -q -W %h:%p bast1";
        };
        "search*" = {
          proxyCommand = "ssh -q -W %h:%p bast1";
        };
        "bk-ci**" = {
          proxyCommand = "ssh -q -W %h.dhcp.bk.cptr.no:%p asbest";
        };
        "*" = {
          user = "pedernot";
          serverAliveInterval = 60;
          forwardX11 = false;
        };
      };
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
      publicKeys = [
        { source = "${config.xdg.dataHome}/gnupg/peder.galteland.pem"; trust = "ultimate"; }
      ];
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraPackages = with pkgs; [
        tree-sitter
        lua-language-server
      ];
    };

    foot = {
      enable = true;
      settings = {
        main = {
          dpi-aware = "yes";
          font = "Hack Nerd Font Mono:size=8, Noto Color Emoji:size=8";
          include = "~/.local/share/tinted-theming/tinty/tinted-terminal-themes-foot-file.ini";
        };
      };

    };

    tmux = {
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type d";
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    jujutsu = {
      enable = true;
      settings = {
        aliases = {
          l = ["log" "-r" "(master..@):: | (master..@)-"];
          sl = ["log" "-l" "20"];
          al = ["log" "-r" "all()"];
          mylog = ["log" "-r" "author('peder.galteland@softwarelab.no')"];
        };
        ui = {
          diff-editor = "vimdirdiff";
          diff.tool = ["difft" "--color=always" "$left" "$right"];
          pager = ":builtin";
        };
        user = {
          email = "peder.galteland@softwarelab.no";
          name = "Peder Notto Galteland";
        };
        signing = {
          # sign-all = true;
          backend = "gpg";
          key = "4980821A221FE5B1";
        };
        git = {
          push-bookmark-prefix = "pedernot/push-";
        };
        fix.tools.ruff-fix = {
          command = ["ruff" "check" "--fix"];
          patterns = ["glob:'**/*.py'"];
        };
        fix.tools.ruff-format = {
          command = ["ruff" "format"];
          patterns = ["glob:'**/*.py'"];
        };
      };
    };

    git = {
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
        ".codespellrc"
        ".jj"
        ".jjconflict*"
        "shell.nix"
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

    gh = {
      enable = true;
      extensions = [
        pkgs.gh-dash
      ];
    };

    newsboat = {
      enable = true;
      extraConfig = builtins.concatStringsSep "\n" [
        (lib.strings.fileContents ./newsboat.conf)
      ];
      urls = [
        {
          url = "https://www.nrk.no/urix/toppsaker.rss";
          tags = ["news"];
        }
        {
          url = "https://www.nrk.no/norge/toppsaker.rss";
          tags = ["news"];
        }
        {
          url = "https://www.nrk.no/trondelag/toppsaker.rss";
          tags = ["news"];
        }
        {
          url = "https://hnrss.org/newest?points=100";
          tags = ["tech" "news"];
        }
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
          url = "http://feeds.feedburner.com/nrkbeta";
          tags = ["news"];
        }
      ];
    };

    mpv = {
      enable = true;
      bindings = {
        "l" = "seek 5";
        "h" = "seek -5";
        "j" = "seek -60";
        "k" = "seek 60";
        "S" = "cycle sub";
      };
    };

    starship = {
      enable = true;
      package = pkgs.starship;
      settings = {
        python = {symbol = " ";};
        rust = {symbol = " ";};
        directory = {fish_style_pwd_dir_length = 1;};
        command_timeout = 1000;
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
  };
}
