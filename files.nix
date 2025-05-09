_: {
  xdg.configFile = {
    "ctags/excludes.ctags".source = ./excludes.ctags;
    # "fontconfig/fonts.conf".source = ./fonts.conf;
    "isync/mbsyncrc".source = ./mbsyncrc;
    "msmtp/config".source = ./msmtp_config;
    "notmuch/notmuchrc".source = ./notmuchrc;
    "tinted-theming/tinty/config.toml".source = ./tinty.toml;

    "mutt" = { source = ./mutt; recursive = true; };
    "systemd/user/" = { source = ./systemd; recursive = true; };

  };
}
