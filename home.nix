{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];
  home.username = "peder";
  home.homeDirectory = "/home/peder";
  home.packages = [
    pkgs.tmux
    pkgs.neovim-nightly
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/nvim/lua/plugins.lua".source = ./plugins.lua;
  home.file.".config/nvim/lua/colors.lua".source = ./colors.lua;
  home.file.".config/nvim/lua/options.lua".source = ./options.lua;
  home.file.".config/nvim/lua/bindings.lua".source = ./bindings.lua;
  home.file.".config/nvim/lua/autocmds.lua".source = ./autocmds.lua;
  home.file.".config/nvim/lua/commands.lua".source = ./commands.lua;
}
