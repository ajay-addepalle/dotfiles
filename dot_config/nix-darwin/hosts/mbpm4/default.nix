
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
    ollama
    uv
  ];


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
      {
        name = "homebrew/services";
        #trusted = true;
      }
      {
        name = "nikitabobko/tap";
        #trusted = true;
      }
      {
        name = "FelixKratz/formulae";
        #trusted = true;
      }
      {
        name = "joncrangle/tap";
      }
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      # SYSTEM TOOLS
      #"mas"
      #"btop"
      #"switchaudio-osx"
      #"nowplaying-cli"
      #"ripgrep"
      "nethogs"
      # WORKSTATION
      "borders"
      "sketchybar"
      "sketchybar-system-stats"
      # LANGAGES
      "lua"
      "luarocks"
      "zig"
      # BUILD TOOL
      "make"
      "gcc"
      "gettext"
      "zig"
      # CLI
      #"zoxide"
      #"starship"
      "mise"
      # DEV TOOLS
      "difftastic"
      #"microsoft-auto-update"
      "dotnet"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      # PRODUCTIVITY
      "alfred"
      "aerospace"
      #"maccy"
      #"obsidian"
      # SOFTWARE
      #"firefox"
      #"google-chrome"
      # DEV
      #"ghostty"
      #"orbstack"
      #"localsend"
      "intellij-idea"
      "visual-studio-code"
      "bruno"
      # agentic tools
      "claude"
      "claude-code"
      # FONTS
      #"sf-symbols"
      #"font-sf-mono"
      #"font-sf-pro"
      #"font-sketchybar-app-font"
      # COMMS
      "discord"
      "microsoft-teams"
      # MEDIA
      "plexamp"
      "plex"
      # NETWORK
      "vnc-viewer"
      "wifiman"
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


}
