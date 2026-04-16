{
    description = "Base System Config";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    };

    outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs : 
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
    in {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
            inherit system; 
            specialArgs = { inherit inputs; };  
            modules = [
                ./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                }
            ];
        };
        packages.${system} = {
            python = import ./modules/shells/python/default.nix { inherit pkgs; };
            node   = import ./modules/shells/nodejs/default.nix { inherit pkgs; };
        };
        devShells.${system} = {
            python = self.packages.${system}.python;
            node   = self.packages.${system}.node;
        };
    };
}