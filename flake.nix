{
  description = "A collection of Nix derivations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    legacyPackages.${system} = pkgs.callPackage ./default.nix { };
  };
}
