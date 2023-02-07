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
    packages.${system} = rec {
      fhs-run = pkgs.callPackage ./fhs-run;
      queercat = pkgs.callPackage ./queercat {};
      processing4 = pkgs.callPackage ./processing4 {};
      wallpaper-engine-kde-plugin = pkgs.callPackage ./we-kde {};
      
      we-kde = throw "This package does not work yet.";
      # we-kde = wallpaper-engine-kde-plugin;
    };
  };
}
