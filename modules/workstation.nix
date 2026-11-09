# Proposed NixOS 26.05 workstation baseline.
# NOT automatically enabled. Import only after reviewing existing /etc/nixos configuration.
# Mirrors the current successful VM setup plus the requested Zsh login shell.
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.qemuGuest.enable = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  networking.firewall.enable = true;
  programs.nix-ld.enable = true;
  services.flatpak.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "z" ];
      theme = "robbyrussell";
    };
  };

  # Setting the login shell declaratively survives rebuilds.
  users.users.johannes.shell = pkgs.zsh;
  users.users.johannes.extraGroups = [ "uinput" ];

  virtualisation.docker.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    enableTCPIP = false;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    neovim git gh curl wget jq ripgrep fd fzf bat eza btop tree
    tmux unzip zip
    docker-compose
    gcc clang clang-tools gdb cmake gnumake pkg-config
    python3 uv ruff
    rustc cargo rust-analyzer
    go nodejs pnpm jdk21
    sqlite postgresql_17
    nmap tcpdump iperf3 dnsutils
  ];

  # Brave is currently installed through Flatpak.
  # VS Code intentionally deferred until its Nixpkgs build issue is resolved.
  #
  # Keep desktop, bootloader, hardware-configuration and system.stateVersion
  # in the existing installer-generated configuration during migration.
}
