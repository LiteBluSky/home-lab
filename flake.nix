{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        username = "ryan"; 
      };
      modules = [
        ./hosts/desktop/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          
          # POINT DIRECTLY TO THE CHEZMOI PROFILE PATH
          # We use an absolute string so Nix evaluates it directly on the disk 
          home-manager.users.ryan = import /home/ryan/.config/home-manager/home.nix;
        }
      ];
    };
  };
}
