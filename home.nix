{ ...  }:

{
  imports = [
    ./packages.nix
    ./programs.nix
    ./xdg.nix
    ./sway.nix
    ./services.nix
  ];

  home = {
    username = "peder";
    homeDirectory = "/home/peder";
    stateVersion = "24.11";
    preferXdgDirectories = true;
    sessionPath = [ "$HOME/.local/bin" ];
  };

  manual.manpages.enable = false;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = ["Noto Color Emoji"];
      monospace = ["Hack Nerd Font Mono"];
    };
  };

  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
  };

  xdg.configFile = {
    "ctags/excludes.ctags".source = ./excludes.ctags;
    "tinted-theming/tinty/config.toml".source = ./tinty.toml;
  };

}
