{
  description = "Ajay's personal system flake: NixOS, nix-darwin";

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
    ...
  }@inputs: 
    let
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
          ] ++ extraModules;
        };

      mkNixos = { hostname, system, username, extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs username hostname; };
          modules = [
            ./hosts/${hostname}
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
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixpkgs-fmt;
    formatter.x86_64-darwin  = nixpkgs.legacyPackages.x86_64-darwin.nixpkgs-fmt;
    formatter.x86_64-linux   = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    formatter.aarch64-linux  = nixpkgs.legacyPackages.aarch64-linux.nixpkgs-fmt;
    };
    # nix code formatter
      #formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    # `nix fmt` ------------------------------------------------------------
}
