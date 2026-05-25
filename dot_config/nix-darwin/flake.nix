{
  description = "Ajay's personal system flake: NixOS, nix-darwin, Home manager";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://cache.nixos.org"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Use `github:NixOS/nixpkgs/nixpkgs-24.11-darwin` to use Nixpkgs 24.11.
    # Use `github:nix-darwin/nix-darwin/nix-darwin-24.11` to use Nixpkgs 24.11.
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs @ {
    self,
    nix-darwin,
    home-manager,
    nixpkgs,
    ...
  }: let
    username = "aaddepalle";
    #system = "aarch64-darwin";
    hostname = "mbpm4";

    specialArgs =
      inputs
      // {
        inherit username hostname;
      };
      # Helpers ---------------------------------------------------------------
      mkDarwin = { hostname, system, username, extraModules ? [] }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs username hostname; };
          modules = [
            ./hosts/${hostname}
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs username hostname; };
              home-manager.users.${username} = import ./home/darwin.nix;
            }
          ] ++ extraModules;
        };

      mkNixos = { hostname, system, username, extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username hostname; };
          modules = [
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs username hostname; };
              home-manager.users.${username} = import ./home/linux.nix;
            }
          ] ++ extraModules;
        };

      # For non-NixOS Linux hosts (Ubuntu/Debian/etc.) where you only manage
      # the user environment, not the system.
      mkHome = { hostname, system, username, extraModules ? [] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = { inherit inputs username hostname; };
          modules = [
            ./home/linux.nix
          ] ++ extraModules;
        };
  in {
    # Build darwin flake using:
    darwinConfigurations = {
      mbpm4 = mkDarwin {
        hostname = "mbpm4";
        system = "aarch64-darwin";
        username = "aaddepalle";
        extraModules = [
          ./modules/nix-core.nix
          ./modules/system.nix
          ./modules/apps.nix
          ./modules/host-users.nix
        ];
      };
    };

    # $ darwin-rebuild build --flake .#mbpm4
    #darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      # inherit system specialArgs;
        #modules = [
        #./modules/nix-core.nix
        #./modules/system.nix
        #./modules/apps.nix
      #./modules/host-users.nix
      #];
    };
    # nix code formatter
      #formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    # `nix fmt` ------------------------------------------------------------
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
    formatter.x86_64-darwin  = nixpkgs.legacyPackages.x86_64-darwin.nixpkgs-fmt;
    formatter.x86_64-linux   = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    formatter.aarch64-linux  = nixpkgs.legacyPackages.aarch64-linux.nixpkgs-fmt;
  };
}
