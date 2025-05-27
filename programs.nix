_: {
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
    ./email.nix
    ./rss.nix
  ];
  programs = {
    home-manager.enable = true;
  };
}
