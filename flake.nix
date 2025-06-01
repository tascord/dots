            {
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
nixos-hardware.url = "github:Nixos/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };
  outputs = inputs@{ self, nixpkgs, ... }: {
    # NOTE: 'nixos' is the default hostname
    nixosConfigurations.floramobile = nixpkgs.lib.nixosSystem {
      modules = [ 
inputs.home-manager.nixosModules.home-manager
	inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
./system/configuration.nix 
{
   home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.flora = ./hm/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
}

];
    };
  };
}

