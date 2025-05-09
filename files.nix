_: {
  xdg.configFile = {
    "ctags/excludes.ctags".source = ./excludes.ctags;
    # "fontconfig/fonts.conf".source = ./fonts.conf;
    "tinted-theming/tinty/config.toml".source = ./tinty.toml;

    "systemd/user/" = { source = ./systemd; recursive = true; };
  };
}
