{ pkgs, ... }:
{
  programs.nix-ld.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "z" ];
      theme = "awesomepanda";
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    enableTCPIP = false;
  };

  environment.systemPackages = with pkgs; [
    neovim git gh curl wget jq ripgrep fd fzf bat eza btop tree tmux unzip zip
    gcc clang clang-tools gdb cmake gnumake pkg-config
    python3 uv ruff
    rustc cargo rust-analyzer
    go nodejs pnpm jdk21 sqlite
  ];
}
