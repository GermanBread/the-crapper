{ joystickwake
, makeWrapper
, runCommand
, util-linux
, findutils
, swayidle
, usbutils
, gnugrep
, gnused
, lib
}:
let
  scriptsModule = import ../lib/modules/scripts.nix {
    inherit runCommand makeWrapper;
    inherit (lib) types;
    inherit lib;
    root = ./bin;
  };
in scriptsModule.evalDefs {
  scripts = {
    zenless-zone-zero.paths = [ joystickwake swayidle ];
    gen-machine-id.paths = [ util-linux ];
    usb-controllers.paths = [ usbutils ];
    fix-plasma-icons.paths = [ gnused ];
    iommu-groups.paths = [ findutils ];
    run-long-command = {};
    latest-nix-shell = {};
    clean-old-gens = {};
    permit-docker = {};
    fhs-shell = {};
    publicip = {};
    nr = {};

    nixpkgs-inspect.aliases = [ "ni" "ne" ];
    nixpkgs-grep = {
      aliases = [ "ng" ];
      paths = [ gnugrep ];
    };
  };
}