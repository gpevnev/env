{
  description = ''
    Flake containing common configurations, hosts setups and shorthands
    for setting up new ones
  '';

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, doom-emacs }@inputs:
    let 
      xmonad-cfg = ./xmonad.hs;
      darwin-pkgs = nixpkgs { system = "x86_64-darwin"; };
      doom-config = ./doom.d;
    in {
      nixosConfigurations.apollo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/apollo 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.greg = import ./hosts/apollo/home.nix { pkgs = nixpkgs.legacyPackages.x86_64-linux; inherit xmonad-cfg; };
          }
        ];
      };
      darwinConfigurations.pioneer = darwin.lib.darwinSystem {
        inherit inputs;
        modules = [ 
          ./hosts/pioneer/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gpevnev = import ./hosts/pioneer/home.nix { 
	      inherit doom-emacs doom-config; 
	    };
          }
        ];
      };
  };
}
