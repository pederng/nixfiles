{
  pkgs,
  ...
}: {
home.file = {
    ".config/dunstrc".source = ./dunstrc;
    ".config/npm/npmrc".source = ./npmrc;
    ".config/ctags/excludes.ctags".source = ./excludes.ctags;
    ".config/fontconfig/fonts.conf".source = ./fonts.conf;
    ".config/isync/mbsyncrc".source = ./mbsyncrc;
    ".config/msmtp/config".source = ./msmtp_config;
    ".config/vim/vimrc_background".source = ./vimrc_background;
    ".config/notmuch/notmuchrc".source = ./notmuchrc;
    ".config/jj/config.toml".source = ./jjconfig.toml;
    ".config/tinted-theming/tinty/config.toml".source = ./tinty.toml;
    ".config/sway/config".source = ./sway.conf;

    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };

    ".config/mutt" = {
      source = ./mutt;
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
}
