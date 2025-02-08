{ pkgs, ... }:

  ###################################################################################
  #
  #  macOS's System configuration
  #
  #  All the configuration options are documented here:
  #    https://daiderd.com/nix-darwin/manual/index.html#sec-options
  #
  ###################################################################################
{

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-reubild changelog
    stateVersion = 5;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      dock = {
        # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-bl-corner

        autohide = true;
        show-recents = false;

	wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1; 

        autohide-delay = 0.2;
	autohide-time-modifier = 0.5;
	# min effects, genie, scale, suck, 
	mineffect = "genie";
	persistent-apps = [
	  "/Applications/Obsidian.app"
	  # "/Applications/Ghostty.app"
          "/Applications/Firefox.app"
	  "/Applications/Safari.app"
	  "/Applications/Discord.app"
	  "/System/Applications/Music.app"
	  "/System/Applications/System Settings.app"
	];
      };

      finder = {
        AppleShowAllExtensions = true;
	AppleShowAllFiles = true;
	FXEnableExtensionChangeWarning = false;
	_FXShowPosixPathInTitle = true;
	_FXSortFoldersFirst = true;
	ShowPathbar = true;
	ShowStatusBar = true;
	# when performing a search, search the current folder by default
	FXDefaultSearchScope = "SCcf";
	# clmv = column view, Nlsv = list view, glyv = gallery view, icnv = icon view
	FXPreferredViewStyle = "clmv";
        NewWindowTarget = "Home";
	QuitMenuItem = true;
	ShowExternalHardDrivesOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
      };

      controlcenter = {
        BatteryShowPercentage = true;
      };

      hitoolbox = {
        AppleFnUsageType = "Do Nothing";
      };

      loginwindow = {
        GuestEnabled = false;
      };

      menuExtraClock = {
        Show24Hour = true;
      };
      trackpad = {
        Clicking = true;
	TrackpadRightClick = true;
	TrackpadThreeFingerDrag = true;

      };
          
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
	ApplePressAndHoldEnabled = false;
	"com.apple.keyboard.fnState" = true;
	AppleInterfaceStyleSwitchesAutomatically = false;
        # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
        # This is very useful for vim users, they use `hjkl` to move cursor.
        # sets how long it takes before it starts repeating.
        InitialKeyRepeat = 15;  # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts. 
        KeyRepeat = 3;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
	# autohide the menu bar
	_HIHideMenuBar = true;
        # move window by holding ctrl + drag mouse
	NSWindowShouldDragOnGesture = true;
	# animate opening and closing window and popover
	NSAutomaticWindowAnimationsEnabled = false;

      };
      # Customize settings that not supported by nix-darwin directly
      # see the source code of this project to get more undocumented options:
      #    https://github.com/rgcr/m-cli
      # 
      # All custom entries can be found by running `defaults read` command.
      # or `defaults read xxx` to read a specific domain.
      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
    };
    ## End Defaults

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = false;
      remapCapsLockToEscape = true;
    };
  };

  time = {
    timeZone = "Asia/Calcutta";
  };
  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;

  environment.shells = [
    pkgs.zsh
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.blex-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.iosevka
    nerd-fonts.hack
    noto-fonts
  ];

 }
