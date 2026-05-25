
{ pkgs, username, hostname, ... }:

{

  # ---------------------------------------------------------------------------
  # nix-darwin system configuration for `mbpm4`.
  # Apply with: darwin-rebuild switch --flake .#mbpm4
  # ---------------------------------------------------------------------------

  networking.hostName = hostname;
  networking.computerName = hostname;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@admin" username ];
  };

  environment.systemPackages = with pkgs; [
  ];

}
