{ joystickwake
, makeWrapper
, runCommand
, util-linux
, findutils
, swayidle
, usbutils
, gnugrep
, gnused
, pkgs # for pkgs.path
, lib
}:
let
  scriptsModule = import ../../lib/modules/scripts.nix {
    inherit runCommand makeWrapper;
    inherit (lib) types;
    inherit lib;
    root = ./bin;
  };
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