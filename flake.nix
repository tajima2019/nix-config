{
  description = "my nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }:
    let
      username = "kento";
    in {
      darwinConfigurations."mac" = 
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit username; };
          modules = [
            ./darwin/default.nix

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                backupFileExtension = "hm-bak";
                extraSpecialArgs = { inherit username; };
                users.${username}.imports = [
                  ./home/common.nix
                  ./home/darwin.nix
                ];
              };
            }
          ];
        };

      homeConfigurations."${username}@arch" = 
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit username; };
          modules = [
            ./home/common.nix
            ./home/linux.nix
          ];
        };
    };
}
