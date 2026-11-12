{
  description = "Home server (NixOS)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { nixpkgs, ... }: {
    # Named after the hostname, so `nixos-rebuild --flake ~/.dotfiles` finds
    # it without `#name`. Home Manager (your user's tools and dotfiles) is
    # separate: ~/.config/home-manager, applied with `home-manager switch`.
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.username = "ryan";
      modules = [ ./hosts/nixos/configuration.nix ];
    };
  };
}
