let
  defaultPkgs = import <nixpkgs> { config.allowUnfree = true; };
in

{
  pkgs ? defaultPkgs,
  ...
}:
{
  own = import ./own { inherit pkgs; };
  foreign = import ./foreign { inherit pkgs; };
}
