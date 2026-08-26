#!/usr/bin/env bash

# ASSUMPTIONS
# /etc/nixos (referred to by this script as: $root) is a symlink to the nixos configuration(s)
# $root/vars.nix exists and exposes: npins inputs (via: import ./npins), an instance of nixpkgs and an instance of nixpkgs' lib
# $root/hosts.nix exists and exposes: KV-pair of hostname and return value of `<nixpkgs/nixos/lib/eval-config.nix>`

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
        inherit (vars) inputs pkgs channel lib vars pkgsUnstable channelUnstable;
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
        hmUsers = hosts."'"$host"'".config.home-manager.users;
        hmConfig = hmUsers."'"$USER"'";
    in '"trace ''
        Loaded expressions from $root:

        Variables in scope:
            hosts      -  all host configs

            vars       -  imported vars.nix
            inputs     -  pinned inputs

            channel    -  current nixpkgs channel (with overlays)
            flakes     -  inputs imported through flake-compat

            pkgs       -  pkgs with overlays
            lib        -  lib with extensions
            pkgsCross  -  pkgs with cross compile

            pkgsUnstable       -  nixos-unstable
            channelUnstable    -  nixos-unstable as channel

        user($USER) variables in scope:
            hmConfig

        host($host) variables in scope:
            config
            options
            _module
            extendModules

        host($host) home-manager variables in scope:
            hmUsers

        utilities (with variables from $host):
            evalNixOS
            evalHomeManager
            evalNixOSWithHM
    ''"' {
        inherit hosts hmConfig hmUsers;
        inherit (vars) pkgs lib inputs channel flakes;
        inherit (hosts."'"$host"'") config options _module extendModules;
        inherit pkgsCross evalNixOS evalHomeManager evalNixOSWithHM;
    }
'