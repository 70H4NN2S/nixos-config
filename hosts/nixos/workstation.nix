{ pkgs, ... }:

{
	# Enable proprietary packages where required
	nixpkgs.config.allowUnfree = true;
	
	# Enable the modern Nix CLI and Flakes.
	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	# Proxmox integration.
	services.qemuGuest.enable = true;

	# Remote administration.
	services.openssh = {
		enable = true;
		settings.PermitRootLogin = "no";
	};

	networking.firewall.enable = true;

	# Compatibility with certain third-party binaries,
	# including VS Code remote tooling.
	programs.nix-ld.enable = true;
	
	# Flatpak: temporary Brave installation
	services.flatpak.enable = true;

	# Zsh and Oh My Zsh.
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;

		ohMyZsh = {
			enable = true;
			plugins = [ "git" "sudo" "z"];
			theme = "awesomepanda";
		};
	};
	
	# Docker Engine
	virtualisation.docker.enable = true;
	
	# PostgreSQL: local-only development database
	services.postgresql = {
		enable = true;
		package = pkgs.postgresql_17;
		enableTCPIP = false;
	};
	
	# default zsh
	users.users.johannes.shell = pkgs.zsh;

	# Workstation applications and tools.
	environment.systemPackages = with pkgs; [
		# GUI applications
		# brave # currently unavailable
		# vscode.fhs
		
		# Editors
		neovim

		# Git and general utilities
		git
		gh
		curl
		wget
		jq
		ripgrep
		fd
		fzf
		bat
		eza
		btop
		tree
		tmux
		unzip
		zip
		
		# Containers
		docker-compose

		# C / C++
		gcc
		clang
		clang-tools
		gdb
		cmake
		gnumake
		pkg-config

		# Python
		python3
		uv
		ruff

		# Rust
		rustc
		cargo
		rust-analyzer
		
		# Go
		go

		# Js / Typescript
		nodejs
		pnpm

		# Java
		jdk21

		# Database tools
		sqlite

		# Networking utilities
		nmap
		tcpdump
		iperf3
		dnsutils
	];
}
