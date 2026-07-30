{
  description = "my nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      username = "kento";
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."${username}@mac" = 
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home/common.nix
            ./home/darwin.nix
          ];
          extraSpecialArgs = { inherit username; };
        };
    };
}
