{
  lib,
  ...
}: {
  # nixpkgs = {
  #   overlays = [
  #     inputs.neovim-nightly-overlay.overlays.default
  #   ];
  # };
  imports = [
    ./ssh.nix
    ./version_control.nix
    ./terminal.nix
    ./nvim.nix
    ./gpg.nix
  ];

  programs = {
    home-manager.enable = true;

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

  };
}
