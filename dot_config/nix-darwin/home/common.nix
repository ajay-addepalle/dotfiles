
{ pkgs, username, hostname, ... }:

{
  # ---------------------------------------------------------------------------
  # Cross-platform Home Manager config — shared between macOS and Linux.
  # Per-OS modules (./darwin.nix, ./linux.nix) import this and add OS-specific
  # bits on top.
  # ---------------------------------------------------------------------------

  imports = [
    #    ./modules/zsh.nix
    #    ./modules/git.nix
    #    ./modules/neovim.nix
  ];

  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  # Packages every machine gets.
  home.packages = with pkgs; [
    #bat
    #eza
    #fd
    #fzf
    #htop
    #jq
    #ripgrep
    #tmux
    #tree
  ];

  # Sensible defaults.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship.enable = true;

  # Don't change once set. See `man home-configuration.nix`.
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
