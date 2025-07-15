{pkgs, ...}: {
  imports = [
    ../common
    ./sway.nix
  ];
  home.packages = with pkgs; [
    hledger
  ];
  home.sessionVariables = {
    LEGDER_FILE = "$HOME/workspace/finances/main.journal";
  };
}
