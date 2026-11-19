{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/development.nix
    ../../modules/networking.nix
    ../../modules/security.nix
    ../../modules/virtualization.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  users.users.johannes = {
    isNormalUser = true;
    description = "johannes";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [ pkgs.kdePackages.kate ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Keep the original installation's compatibility version.
  system.stateVersion = "26.05";
}
