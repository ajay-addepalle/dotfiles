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
    devenv
    git
    mkalias
    rsync
    neovim
    just
    chezmoi
    zsh
    fzf
    ollama
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
      "btop"
      "switchaudio-osx"
      "nowplaying-cli"
      "ripgrep"
      # WORKSTATION
      "borders"
      "sketchybar"
      # LANGAGES
      "lua"
      "luarocks"
      "zig"
      # BUILD TOOL
      "make"
      "gcc"
      # CLI
      "zoxide"
      "starship"
      "mise"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      # PRODUCTIVITY
      "alfred"
      "aerospace"
      "maccy"
      "obsidian"
      # SOFTWARE
      "firefox"
      "google-chrome"
      "synology-drive"
      "synergy-core"
      "vnc-viewer"
      # DEV
      "ghostty"
      "orbstack"
      "localsend"
      "intellij-idea"
      "visual-studio-code"
      # FONTS
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
      "font-sketchybar-app-font"
      # COMMS
      "discord"
      # MEDIA
      "plexamp"
      "plex"
      # NETWORK
      "tailscale"
      "vnc-viewer"
    ];
    masApps = {
    };
  };
  launchd = {
    user = {
      agents = {
        ollama-serve = {
          command = "${pkgs.ollama}/bin/ollama serve";
          serviceConfig = {
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/ollama.out.log";
            StandardErrorPath = "/tmp/ollama.err.log";
          };
        };
      };
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
