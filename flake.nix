{
  description = "Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
    let
      inherit (self) outputs;
    in
    {
    packages.x86_64-linux = home-manager.packages.x86_64-linux;

    homeConfigurations = {
      "peder" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [./home.nix];
        extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
