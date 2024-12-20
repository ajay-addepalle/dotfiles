{
  description = "Ajay's nix-darwin system flake";

  # the nixConfig here only affects the flake itself, not the system configuration!
  # Picked up from https://github.com/ryan4yin/nix-darwin-kickstarter
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # official packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # macos stuff
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    
  };
  
  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = { 
    self, 
    nix-darwin, 
    nixpkgs, 
    nix-homebrew, 
    homebrew-core, 
    homebrew-cask, 
    homebrew-bundle,
    ...
  } @inputs: let
    configuration = { 
      pkgs,
      lib,
      config,
      ... 
    }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        mkalias
	rsync
        git
	neovim
        chezmoi
	obsidian
	maccy
      ];

      fonts.packages = with pkgs; [
      	nerd-fonts.fira-code
	nerd-fonts.blex-mono
	nerd-fonts.caskaydia-cove
	noto-fonts
      ];

      homebrew = {
        enable = true;
        onActivation = {
         autoUpdate = true;
         cleanup = "uninstall";
         upgrade = true;
        };
	brews = [
	  "mas"
	];
        casks = [
        ];
	taps = [
	];
	masApps = {
          Boop = 1518425043;
	};
      }; 

      #system.activationScripts.applications.text = lib.mkForce ''
      #    # Set up applications.
      #    echo "setting up /Applications/Nix Apps..." >&2
      #    appsSrc="${config.system.build.applications}/Applications/"
      #    baseDir="/Applications/Nix Apps"
      #    rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
      #    mkdir -p "$baseDir"
      #    ${pkgs.rsync}/bin/rsync "$rsyncArgs" "$appsSrc" "$baseDir"
      # '';

      #Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mbpm4
    darwinConfigurations."mbpm4" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "aaddepalle";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
      ];
    };
    
    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mbpm4".pkgs;
  };
}
