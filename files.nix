{
  pkgs,
  ...
}: {
  xdg.configFile = {
    "dunstrc".source = ./dunstrc;
    "npm/npmrc".source = ./npmrc;
    "ctags/excludes.ctags".source = ./excludes.ctags;
    "fontconfig/fonts.conf".source = ./fonts.conf;
    "isync/mbsyncrc".source = ./mbsyncrc;
    "msmtp/config".source = ./msmtp_config;
    "vim/vimrc_background".source = ./vimrc_background;
    "notmuch/notmuchrc".source = ./notmuchrc;
    "tinted-theming/tinty/config.toml".source = ./tinty.toml;

    "nvim" = { source = ./nvim; recursive = true; };
    "mutt" = { source = ./mutt; recursive = true; };
    "systemd/user/" = { source = ./systemd; recursive = true; };

  };

  xdg.dataFile = {
    "gnupg/peder.galteland.pem".source = ./peder.galteland.pem;
    "gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 86400
        max-cache-ttl 86400
        pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt
        enable-ssh-support
    '';
  };

  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
  };
}
