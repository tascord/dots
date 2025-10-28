{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:Nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:tascord/zen-nix";
    plymouth-theme.url = "path:/home/flora/dots/flakes/plymouth-theme-custom";
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, zen-browser,vicinae, ... }: 
  let system = "x86_64-linux"; in {
    nixosConfigurations.floramobile = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit system;
        inherit inputs;
        inherit zen-browser;
      };

      modules = [

        inputs.home-manager.nixosModules.home-manager
        inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
        ./system/configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.flora = ./hm/home.nix;
          environment.systemPackages = [
            vicinae.packages.x86_64-linux.default
          ];
        }

      ];
    };
  };
}
