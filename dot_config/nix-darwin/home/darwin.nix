
{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  # macOS-only packages and tweaks.
  home.packages = with pkgs; [
    # mas       # Mac App Store CLI
    # coreutils # GNU coreutils alongside macOS's BSD versions
  ];
}
