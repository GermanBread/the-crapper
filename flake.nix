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
      wallpaper-engine-kde-plugin = pkgs.libsForQt5.callPackage ./we-kde {};
      
      we-kde = wallpaper-engine-kde-plugin;
    };
  };
}
