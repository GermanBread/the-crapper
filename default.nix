args: let
  own = import ./own args;
  foreign = import ./foreign args;
  modules = {
    nixos = import ./nixos args;
    home-manager = import ./home-manager args;
  };
in modules // own // foreign