{ ...  }:

{
  imports = [
    ./packages.nix
    ./files.nix
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
  fonts.fontconfig.enable = true;

  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
  };

}
