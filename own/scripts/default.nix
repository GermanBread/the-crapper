{ pkgs, lib, ... }:
let
  scriptsModule = import ../../lib/modules/scripts.nix {
    inherit (pkgs) runCommandNoCC makeWrapper;
    inherit (lib) types;
    inherit lib;
  };
  
  inherit (pkgs)
    util-linux
    findutils
    usbutils
    gnugrep
    gnused
    ;
in scriptsModule.evalDefs {
  scripts = {
    run-long-command = {};
    clean-old-gens = {};
    gen-machine-id = { paths = [ util-linux ]; };
    nixpkgs-grep = {
      substitutions = {
        "nixpkgs" = "${pkgs.path}";
      };
      aliases = [ "ng" ];
      paths = [ gnugrep ];
    };
    nr = {};
    publicip = {};
    fhs-shell = {};
    sandbox-shell = {};
    iommu-groups = {
      paths = [ findutils ];
    };
    usb-controllers = {
      paths = [ usbutils ];
    };
    fix-plasma-icons = {
      paths = [ gnused ];
    };
  };
}