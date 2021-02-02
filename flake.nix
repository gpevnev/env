{
  description = ''
    Flake containing common configurations, hosts setups and shorthands
    for setting up new ones
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    home-manager.url = "github:nix-community/home-manager/release-20.09";
  };

  outputs = { self, nixpkgs, home-manager }:
    let xmonad-cfg = ./xmonad.hs;
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
  };
}
