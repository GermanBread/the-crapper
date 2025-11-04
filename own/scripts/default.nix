{ pkgs, lib, ... }:
let
  scriptsModule = import ../../lib/modules/scripts.nix {
    inherit (pkgs) runCommandNoCC makeWrapper;
    inherit (lib) types;
    inherit lib;
    root = ./bin;
  };
  
  inherit (pkgs)
    joystickwake
    util-linux
    findutils
    swayidle
    usbutils
    gnugrep
    gnused
    ;
in scriptsModule.evalDefs {
  scripts = {
    gen-machine-id.paths = [ util-linux ];
    usb-controllers.paths = [ usbutils ];
    zzz.paths = [ joystickwake swayidle ];
    fix-plasma-icons.paths = [ gnused ];
    iommu-groups.paths = [ findutils ];
    run-long-command = {};
    latest-nix-shell = {};
    clean-old-gens = {};
    sandbox-shell = {};
    fhs-shell = {};
    publicip = {};
    nr = {};

    nixpkgs-grep = {
      substitutions = {
        "nixpkgs" = "${pkgs.path}";
      };
      aliases = [ "ng" ];
      paths = [ gnugrep ];
    };
  };
}