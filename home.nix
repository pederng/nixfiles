{
  pkgs,
  ...
}: {
  imports = [
    ./packages.nix
    ./files.nix
    ./programs.nix
    ./xdg.nix
    ./sway.nix
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  home = {
    username = "peder";
    homeDirectory = "/home/peder";
    stateVersion = "24.11";
  };
  manual.manpages.enable = false;
  fonts.fontconfig.enable = true;
}
