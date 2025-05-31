#!/usr/bin/env bash

# ASSUMPTIONS
# /etc/nixpkgs is a symlink to the system's ${pkgs.path}
# /etc/nixos is a symlink to the system config (may be in the store)

host="$(hostname -s)"

{
    set -e
    root=$(git rev-parse --show-toplevel 2>/dev/null)
    [ -e "$root/hosts.nix" ]
    [ -e "$root/vars.nix" ]
} || root="$(realpath /etc/nixos)"

exec nix repl --expr '
    let
        vars = import '"$root/vars.nix"';
        hosts = import '"$root/hosts.nix"';
        inherit (builtins) trace;
        inherit (vars) inputs pkgs lib;
        inherit (lib) flatten;
        inherit (pkgs) pkgsCross nixos;
        commoncfg = {
            nixos = {
                system.stateVersion = lib.trivial.release;
                users.users."'"$USER"'" = {
                    isNormalUser = true;
                    home = "'"$HOME"'";
                };
            };
            hm = {
                home = {
                    username = "'"$USER"'";
                    homeDirectory = "'"$HOME"'";
                    stateVersion = lib.trivial.release;
                };
            };
        };
        evalNixOS = mod: nixos ([ commoncfg.nixos ] ++ (flatten [ mod ]));
        evalHomeManager = mod: let
            imported = import inputs.home-manager { inherit pkgs; };
        in imported.lib.homeManagerConfiguration {
            inherit pkgs lib;
            modules = [ commoncfg.hm ] ++ (flatten [ mod ]);
        };
        evalNixOSWithHM = modNixOS: modHm:
            evalNixOS [
                modNixOS (inputs.home-manager + "/nixos")
                { home-manager.users."'"$USER"'".imports = [
                    commoncfg.hm
                ] ++ (flatten [ modHm ]); }
            ];
    in '"trace ''
        Loaded expressions from $root:

        Variables in scope:
            hosts      -  all host configs

            inputs     -  pinned inputs
            flakes     -  inputs imported through flake-compat

            pkgs       -  pkgs with overlays
            lib        -  lib with extensions
            pkgsCross  -  pkgs with cross compile

        $host variables in scope:
            config
            options
            _module
            extendModules

        utilities (with variables from $host):
            evalNixOS
            evalHomeManager
            evalNixOSWithHM
    ''"' {
        inherit hosts;
        inherit (vars) pkgs lib inputs flakes;
        inherit (hosts."'"$host"'") config options _module extendModules;
        inherit pkgsCross evalNixOS evalHomeManager evalNixOSWithHM;
    }
'