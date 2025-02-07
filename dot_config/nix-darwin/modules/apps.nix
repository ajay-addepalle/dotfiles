{ pkgs, config, username, ...}: {

  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  # List packages installed in system profile. To seach by name, run:
  # nix-env -qaP | grep wget  
  environment.systemPackages = with pkgs; [
    git
    mkalias
    rsync
    neovim
    just
    chezmoi
    zsh
    fzf
  ];

  environment.variables = {
    EDITOR = "nvim";
    ZSH = "$HOME/.oh-my-zsh";
    ZSH_CACHE_DIR = "$HOME/.cache/ohmyzsh";
  };

  # TODO To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "uninstall";
    };

    taps = [
      "homebrew/services"
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      # SYSTEM TOOLS
      "mas"
      "borders"
      "sketchybar"
      "lua"
      "switchaudio-osx"
      "nowplaying-cli"
      # CLI
      "zoxide"
      "starship"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      # SYSTEM TOOLS
      "alfred"
      "firefox"
      "google-chrome"
      "aerospace"
      "maccy"
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"

      # COMMS
      "discord"

      # PRODUCTIVITY
      "obsidian"

      # MEDIA
      "plexamp"
      "plex"

      # NETWORK
      "tailscale"
      "vnc-viewer"

      # TERMINAL
      "ghostty"
      
    ];
    masApps = {
    };
  };

/*
  system.activationScripts.applications.text = pkgs.lib.mkForce ''
    # Set up applications.
    echo "setting up /Applications/Nix Apps..." >&2
    appsSrc="$HOME/Applications/"
    baseDir="/Applications/Nix Apps"
    mkdir -p "$baseDir"
    ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$appsSrc" "$baseDir"
  '';
*/
}
