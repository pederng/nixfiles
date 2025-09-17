{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    # ./mipi.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["btrfs"];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  hardware = {
    enableAllFirmware = true;
    graphics.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "lapping";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Oslo";

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.waylock = {};
  };

  virtualisation.docker.enable = true;

  programs = {
    nix-ld.enable = true;
    gnupg.agent.enable = true;
    zsh.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
  ];

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    hardware.bolt.enable = true;
    tailscale.enable = true;
    resolved.enable = true;
  };

  users.users.peder = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
