{ callPackages }: let
  own = callPackages ./own {};
  foreign = callPackages ./foreign {};
in own // foreign