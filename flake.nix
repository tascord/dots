{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:Nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    plymouth-theme.url = "path:/home/flora/dots/flakes/plymouth-theme-custom";
  };

  outputs = inputs@{ self, nixpkgs, hyprpanel, ... }: 
  let system = "x86_64-linux"; in {
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations.floramobile = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit system;
        inherit inputs;
      };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
        ./system/configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.flora = ./hm/home.nix;
          nixpkgs.overlays = [inputs.hyprpanel.overlay];
        }

      ];
    };
  };
}
