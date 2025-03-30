{ pkgs, lib, ... }:

{
  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    # Enable alternative shell support in nix-darwin
    # programs.fish.enable = true

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    builders-use-substitutes = true;

  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Auto upgrade nix package and the daemon service.
  # Removed nix-daemon.enable from new version
  # services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  
  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    options = lib.mkDefault "--delete-older-than 7d";
  };
}
