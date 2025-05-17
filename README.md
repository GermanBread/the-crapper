A collection of Nix packages and NixOS modules

NixOS import:

```nix
{
  imports = [ (inputs.stuffs + /nixos/<modulename>) ];
}
```

Home-Manager import:

```nix
{
  imports = [ (inputs.stuffs + /home-manager/<modulename>) ];
}
```

Packages:

 - `nix-env -if pkgs -A <name>`
 - `nix-build pkgs -A <name>`
 - `import ./pkgs { [ARGS] ... }`